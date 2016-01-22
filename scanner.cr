require "./token"

class Scanner
  def initialize(@file_name)
    @tokens = [] of Token
    @file_content = File.read(@file_name) + '\0'
    @iterator = 0
    @line = 1
    @pos = 1
    @current_char = @file_content[@iterator]
    @previous_char = nil
  end

  def run
    until @tokens.any? && @tokens.last.is_eof?
      @tokens << next_token
    end
    self
  end

  def next_token
    skip_spaces
    if is_letter?
      parse_identificator
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

  def parse_identificator
    identificator = ""
    pos = @pos
    while is_letter?
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
    @tokens.map(&.to_s).join('\n')
  end
end