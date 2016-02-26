class Token
  def initialize(@line, @pos, @type, @name) # todo: name -> text
  end

  def name
    @name
  end

  def to_s
    "#{@line}\t#{@pos}\t#{@type}\t\t#{@name}"
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

  # Checkers

  def is_semicolon?
    is_separator? && @name == ";"
  end
end