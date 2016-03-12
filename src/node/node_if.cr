class NodeIf < Node
  def initialize(@condition : Node, @if_true : Node, @if_false : Node | Nil)
  end

  def to_s(level = 0, have_link = false)
    "if\n" +
    draw_path(level, have_link) +
    @condition.to_s(level + 1, true) +
    draw_path(level, have_link) +
    @if_true.to_s(level, true) +
    draw_path(level, have_link) +
    @if_false.to_s(level + 1, false)
  end
end