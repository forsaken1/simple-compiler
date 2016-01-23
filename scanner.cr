require "./token"
require "./exceptions"
require "./monkey_patching"

class Scanner
  def initialize(@file_name)
    @tokens = [] of Token
    @file_content = File.read(@file_name) + '\0'
    @iterator = 0
    @line = 1
    @pos = 1
    @current_char = @file_content[@iterator]
    @previous_char = nil
    @exception = nil
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
    elsif is_number?
      parse_number
    elsif is_eof?
      parse_eof
    else
      parse_unknown
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

  def parse_number
    number = ""
    pos = @pos
    while is_number? || is_dot?
      number += @current_char
      next_char
    end
    raise ScannerException.new("Invalid identificator: \"#{number}#{parse_identificator.name}\"").with_info(@line, pos) if is_letter?
    if number.have_dot?
      Token.new @line, pos, :float, number
    elsif number.have_dots?
      raise ScannerException.new("Invalid float: \"#{number}\"").with_info @line, pos
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

  def to_s
    if @exception
      @exception.to_s
    else
      @tokens.map(&.to_s).join('\n')
    end
  end
end