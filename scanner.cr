require "./token"
require "./exceptions"
require "./monkey_patching"

class Scanner
  def initialize(@file_name)
    @tokens = [] of Token
    @file_content = File.read(@file_name) + '\0'
    @iterator, @line, @pos = 0, 1, 1
    @previous_char, @exception = nil, nil
    @operations = ["+", "+=", "-", "-=", "*", "*=", "/", "/="].map { |op| [op, true] }.to_h
    @it_can_be_operation = ["-", "+", "*", "/"].map { |op| [op, true] }.to_h
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

  def next_token
    skip_spaces
    if is_letter?
      parse_identificator
    elsif is_number? || is_dot?
      parse_number
    elsif is_operation?
      parse_operation
    elsif is_eof?
      parse_eof
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

  def next_char
    @previous_char = @current_char
    @current_char = @file_content[inc_iterator!]
    @pos += 1
    if @previous_char == '\n'
      @line += 1
      @pos = 1
    end
  end

  def parse_operation
    operation = @current_char.to_s
    pos = @pos
    until @operations[operation]
      next_char
      operation += @current_char
      raise ScannerException.new("lol").with_info(@line, pos) if operation.size > 3
    end
    Token.new @line, pos, :operation, operation
  end

  def parse_number
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
    raise ScannerException.new("Invalid identificator: \"#{number}#{parse_identificator.name}\"").with_info(@line, pos) if is_letter?
    if number.have_dot? || number.have_e?
      raise ScannerException.new("Too many dots in real number: \"#{number}\"").with_info(@line, pos) if number.have_dots?
      raise ScannerException.new("Too many symbol \"E\" in real number: \"#{number}\"").with_info(@line, pos) if number.have_many_e?
      raise ScannerException.new("Invalid real number: \"#{number}\"").with_info(@line, pos) unless number.valid_real_number?
      Token.new @line, pos, :float, number
    else
      Token.new @line, pos, :integer, number
    end
  end

  def parse_identificator
    identificator = ""
    pos = @pos
    while is_letter? || is_number?
      identificator += @current_char
      next_char
    end
    Token.new @line, pos, :identificator, identificator
  end

  def parse_eof
    Token.new @line, @pos, :eof, "End of file"
  end

  def parse_unknown
    Token.new @line, @pos, :unknown, "Unknown symbol"
  end

  def skip_spaces
    while is_space?
      next_char
    end
  end

  def is_operation?
    @it_can_be_operation[@current_char.to_s]
  end

  def is_minus?
    @current_char == '-'
  end

  def is_e?
    @current_char == 'E' || @current_char == 'e'
  end

  def is_dot?
    @current_char == '.'
  end

  def is_number?
    '0' <= @current_char <= '9'
  end

  def is_letter?
    'a' <= @current_char <= 'z' || 'A' <= @current_char <= 'Z' || @current_char == '_'
  end

  def is_space?
    @current_char == ' '
  end

  def is_eof?
    @current_char == '\0'
  end

  def inc_iterator!
    @iterator += 1
  end
end