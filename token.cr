class Token
  def initialize(@line, @pos, @type, @name)
  end

  def to_s
    "#{@line}\t#{@pos}\t#{@type}\t\t#{@name}"
  end

  def is_eof?
    @type == :eof
  end
end