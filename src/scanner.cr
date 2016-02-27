require "./token"
require "./exceptions"
require "./monkey_patching/string"

class Scanner
  def initialize(@file_name)
    @tokens = [] of Token
    @file_content = File.read(@file_name) + '\0'
    @iterator, @line, @pos = 0, 1, 1
    @previous_char, @exception = '\0', nil

    @it_can_be_operation = ["-", "+", "*", "/", "=", "%", "<", ">", "!", "&", "|", "^", "?", ":", "."].map { |op| [op, true] }.to_h
    @operations = ["+=", "-=", "*=", "/=", "%=", "&=", "|=", "^=", "->", "==", ">=", "<=", "!=", "++", "--", ">>", "<<", "||", "&&"].map { |op| [op, true] }.to_h.merge @it_can_be_operation
    @escapes = ["n", "t", "v", "b", "a", "r", "f", "'", "\"", "\\", "?"].map { |e| [e, true] }.to_h
    @separators = ["(", ")", "[", "]", "{", "}", ";", ","].map { |s| [s, true] }.to_h
    @keywords = ["int", "char", "for", "return", "while"].map { |k| [k, true] }.to_h

    @current_char = @file_content[@iterator]
  end

  def run
    until @tokens.any? && @tokens.last.is_eof?
      @tokens << next_token
    end
  rescue ex : ScannerException
    @exception = ex
  else
    self
  end

  def next_token : Token
    skip_spaces!
    while is_comment_begin?
      parse_comment
      skip_spaces!
    end
    if is_letter?
      parse_identificator
    elsif is_operation?
      parse_operation
    elsif is_number? || is_dot?
      parse_number
    elsif is_char_separator?
      parse_char
    elsif is_string_separator?
      parse_string
    elsif is_eof?
      parse_eof
    elsif is_separator?
      parse_separator
    else
      parse_unknown
    end
  end

  def to_s
    if @exception
      @exception.to_s
    else
      @tokens.map(&.to_s).join('\n')
    end
  end



  private def next_char
    @previous_char = @current_char
    @current_char = @file_content[inc_iterator!]
    @pos += 1
    if @previous_char == '\n'
      @line += 1
      @pos = 1
    end
  end

  private def parse_comment
    next_char
    if is_asterisk?
      until is_slash? && @previous_char == '*'
        next_char
        raise ScannerException.new("Unexpected end of file").with_info(@line, @pos) if is_eof?
      end
    else
      until is_eol? || is_eof?
        next_char
      end
    end
    next_char unless is_eof?
  end

  private def parse_separator
    separator = @current_char.to_s
    pos = @pos
    next_char
    Token.new @line, pos, :separator, separator
  end

  private def parse_string
    pos = @pos
    string = ""
    next_char
    until is_string_separator?
      raise ScannerException.new("Unexpected end of file").with_info(@line, @pos) if is_eof?
      string += @current_char
      next_char
    end
    next_char
    Token.new @line, pos, :string, string
  end

  private def parse_char # refactoring
    pos = @pos
    char = ""
    token_type = :char
    next_char
    if is_backslash?
      char += @current_char
      token_type = :escape
      next_char
      if @escapes[@current_char.to_s]?
        char += @current_char
        next_char
        if is_char_separator?
          next_char
        else
          raise ScannerException.new("Invalid character constant").with_info(@line, pos)
        end
      else
        raise ScannerException.new("Invalid ESCAPE-sequence: \"#{char + @current_char}\"").with_info(@line, pos)
      end
    else
      if is_char? # shit
        char += @current_char
        next_token
        if is_char_separator?
          next_char
        else
          # raise
        end
      else
        raise ScannerException.new("Invalid character constant").with_info(@line, pos)
      end
    end
    Token.new @line, pos, token_type, char
  end

  private def parse_operation
    pos = @pos
    next_char
    operation = @previous_char.to_s + @current_char.to_s
    if @operations[operation]?
      next_char
      Token.new @line, pos, :operation, operation
    else
      Token.new @line, pos, :operation, operation[0].to_s
    end
  end

  private def parse_number # refactoring
    number = ""
    pos = @pos
    while is_number? || is_dot? || is_e?
      number += @current_char
      next_char
      if is_minus? && (@previous_char == 'e' || @previous_char == 'E') # shit
        number += @current_char
        next_char
      end
    end
    raise ScannerException.new("Invalid identificator: \"#{number}#{parse_identificator.text}\"").with_info(@line, pos) if is_letter?
    if number.have_dot? || number.have_e?
      raise ScannerException.new("Invalid real number: \"#{number}\"").with_info(@line, pos) unless number.valid_real_number?
      Token.new @line, pos, :float, number
    else
      Token.new @line, pos, :integer, number
    end
  end

  private def parse_identificator
    identificator = ""
    pos = @pos
    token_type = :identificator
    while is_letter? || is_number?
      identificator += @current_char
      next_char
    end
    token_type = :keyword if keyword?(identificator)
    Token.new @line, pos, token_type, identificator
  end

  private def parse_eof
    Token.new @line, @pos, :eof, "End of file"
  end

  private def parse_unknown
    raise ScannerException.new("Indefinite character: \"#{@current_char}\"").with_info(@line, @pos)
  end



  private def skip_spaces!
    while is_space? || is_eol? || is_tab? || is_carriage_return?
      next_char
    end
  end

  private def inc_iterator!
    @iterator += 1
  end

  private def dec_iterator!
    @iterator -= 1
  end

  private def keyword?(identificator)
    @keywords[identificator]?
  end

  private def future_char
    @file_content[@iterator + 1]
  end



  private def is_carriage_return?
    @current_char == '\r'
  end

  private def is_comment_begin?
    is_slash? && (future_char == '/' || future_char == '*')
  end

  private def is_slash?
    @current_char == '/'
  end

  private def is_asterisk?
    @current_char == '*'
  end

  private def is_separator?
    @separators[@current_char.to_s]?
  end

  private def is_operation?
    @it_can_be_operation[@current_char.to_s]?
  end

  private def is_string_separator?
    @current_char == '"'
  end

  private def is_char_separator?
    @current_char == '\''
  end

  private def is_backslash?
    @current_char == '\\'
  end

  private def is_minus?
    @current_char == '-'
  end

  private def is_e?
    @current_char == 'E' || @current_char == 'e'
  end

  private def is_dot?
    @current_char == '.'
  end

  private def is_tab?
    @current_char == '\t'
  end

  private def is_char?
    is_number? || is_letter?
  end

  private def is_number?
    '0' <= @current_char <= '9'
  end

  private def is_letter?
    'a' <= @current_char <= 'z' || 'A' <= @current_char <= 'Z' || @current_char == '_'
  end

  private def is_space?
    @current_char == ' '
  end

  private def is_eof?
    @current_char == '\0'
  end

  private def is_eol?
    @current_char == '\n'
  end
end