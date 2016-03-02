

class Parser

  private property scanner

  def initialize(@scanner : Scanner)
    @current_token = uninitialized Token
    @ast = uninitialized Node # abstract syntax tree
  end

  def run : Node
    next_token
    @ast = expression_statement
  end

  def to_s
    @ast.to_s
  end

  private def expression_statement : NodeStatement
    expr = expression
    if @current_token.is_semicolon?
      next_token
    end
    NodeStatement.new expr
  end

  private def expression(n = 0) : Node
    return unary_expression if n > 14
    #case n of
    #when 0: 
    #end
    expression n + 1
  end

  private def unary_expression : Node
    postfix_expression
  end

  private def postfix_expression : Node
    primary_expression
  end

  private def primary_expression : Node
    node = if @current_token.is_identificator?
      NodeIdentificator.new @current_token
    elsif @current_token.is_constant?
      NodeConstant.new @current_token
    elsif @current_token.is_string?
      NodeString.new @current_token
    elsif @current_token.is_left_bracket?
      expression
    else
      raise ParserException.new
    end
    next_token
    node
  end

  private def next_token : Token
    @current_token = scanner.next_token
  end
end