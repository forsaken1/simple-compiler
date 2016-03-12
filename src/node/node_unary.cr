class NodeUnary < Node
  def initialize(@operation : Token, @operand : Node)
  end

  def to_s(level = 0, have_link = false)
    "(#{@operation.text})\n" +
    draw_path(level, have_link) +
    @operand.to_s(level + 1, false)
  end
end