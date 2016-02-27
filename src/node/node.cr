class Node
  def initialize(@token : Token)
  end

  def to_s
    "(#{@token.text})"
  end
end