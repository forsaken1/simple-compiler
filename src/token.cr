class Token
  getter text, type, line, pos, unary_operator, binary_operator, type_name

  def initialize(@line, @pos, @type, @text)
    @unary_operator = ["&", "*", "+", "-", "~", "!"].map { |e| [e, true] }.to_h
    @binary_operator = ["||", "&&", "|", "^", "&", "==", "!=", "<", ">", "<=", ">=", ">>", "<<", "*=", "/=", "+=", "-=", "+", "-", "*", "/", "%", "<>"].map { |e| [e, true] }.to_h
    @type_name = ["char", "int", "float", "void"].map { |e| [e, true] }.to_h
  end

  def to_s
    "#{@line}\t#{@pos}\t#{@type}\t\t#{@text}"
  end

  # Type checkers

  def is_eof?
    @type == :eof
  end

  def is_keyword?
    @type == :keyword
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

  def is_binary_operation?
    is_operation? && binary_operator[@text]?
  end

  def is_type_name?
    is_keyword? && type_name[@text]?
  end

  def is_unary_operator?
    is_operation? && unary_operator[@text]?
  end

  def is_question?
    is_operation? && @text == "?"
  end

  def is_comma?
    is_separator? && @text == ","
  end

  def is_arrow?
    is_operation? && @text == "->"
  end

  def is_point?
    is_operation? && @text == "."
  end

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

  def is_colon?
    is_operation? && @text == ":"
  end

  def is_semicolon?
    is_separator? && @text == ";"
  end
end