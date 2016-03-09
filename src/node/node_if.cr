class NodeIf < Node
  def initialize(@condition : Node, @if_true : Node, @if_false : Node | Nil)
  end

  def to_s
    "if\n" \
    "|\n" \
    "+---#{@condition.to_s}\n" \
    "|\n" \
    "+---#{@if_true.to_s}\n" \
    "|\n" \
    "+---#{@if_false.to_s}\n"
  end
end