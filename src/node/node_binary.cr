class NodeBinary < Node
  def initialize(@left : Node, @operation : Token, @right : Node)
  end

  def to_s(level = 0, have_link = false)
    "(#{@operation.text})\n" +
    draw_path(level, have_link) +
    @left.to_s(level + 1, true) +
    draw_path(level, have_link) +
    @right.to_s(level + 1, false)
  end
end