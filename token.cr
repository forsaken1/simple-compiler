class Token
  def initialize(@line, @pos, @type, @name)
  end

  def to_s
    "#{@line}\t#{@pos}\t#{@type}\t\t#{@name}"
  end
end