class Token
  def initialize(@line, @pos, @type, @name)
  end

  def name
    @name
  end

  def to_s
    "#{@line}\t#{@pos}\t#{@type}\t\t#{@name}"
  end

  def is_eof?
    @type == :eof
  end
end