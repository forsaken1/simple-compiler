class Token
  getter text, line, pos

  def initialize(@line, @pos, @type, @text)
  end

  def to_s
    "#{@line}\t#{@pos}\t#{@type}\t\t#{@text}"
  end

  # Type checkers

  def is_eof?
    @type == :eof
  end

  def is_identificator?
    @type == :identificator
  end

  def is_separator?
    @type == :separator
  end

  def is_char?
    @type == :char
  end

  def is_escape?
    @type == :escape
  end

  def is_string?
    @type == :string
  end

  def is_integer?
    @type == :integer
  end

  def is_float?
    @type == :float
  end

  def is_operation?
    @type == :operation
  end

  # Checkers

  def is_left_square_bracket?
    is_separator? && @text == "["
  end

  def is_right_square_bracket?
    is_separator? && @text == "]"
  end

  def is_increment?
    is_operation? && @text == "++"
  end

  def is_decrement?
    is_operation? && @text == "--"
  end

  def is_constant?
    is_char? || is_escape? || is_integer? || is_float?
  end

  def is_left_bracket?
    is_separator? && @text == "("
  end

  def is_right_bracket?
    is_separator? && @text == ")"
  end

  def is_semicolon?
    is_separator? && @text == ";"
  end
end