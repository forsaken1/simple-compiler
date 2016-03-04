class NodeUnary < Node
  def initialize(@operation : Token, @operand : Node)
  end

  def to_s
    "(#{@operation.text})\n" \
    "|\n" \
    "+---#{@operand.to_s}\n"
  end
end