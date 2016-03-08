class Parser
  private property scanner
  private getter   current_token, next_token, previous_token

  def initialize(@scanner : Scanner)
    @previous_token = uninitialized Token
    @current_token = uninitialized Token
    @next_token = scanner.next_token
    @ast = uninitialized Node # abstract syntax tree
  end

  def run
    next_token!
    @ast = program
    self
  rescue ex : SimpleCompilerException
    ex
  end

  def to_s
    @ast.to_s
  end



  def program : Node
    external_declaration
  end

  def external_declaration : Node
    statement_list
  end

  def statement_list : NodeStatement
    expression_statement
  end

  private def expression_statement : NodeStatement
    expr = expression
    if current_token.is_semicolon?
      next_token!
    else
      raise ParserException.new "Expression without ';'", current_token
    end
    NodeStatement.new expr
  end

  private def expression : Node
    left_expr = assignment_expression
    if current_token.is_comma?
      operation = current_token
      next_token!
      right_expr = expression
      NodeBinary.new left_expr, operation, right_expr
    else
      left_expr
    end
  end

  private def assignment_expression : Node
    conditional_expression
  end

  private def conditional_expression : Node
    binary_expression
  end

  private def binary_expression(n = 0) : Node
    return cast_expression if n > 10
    left_expr = 
    expression n + 1
  end

  private def cast_expression : Node
    if current_token.is_left_bracket?
      if next_token.is_type_name?
        next_token!
        type_name = current_token
        next_token!
        unless current_token.is_right_bracket?
          raise ParserException.new "Unexpected token '#{current_token.text}, expected ')'", current_token
        end
        next_token!
        return NodeUnary.new type_name, unary_expression
      end
    end
    unary_expression
  end

  private def unary_expression : Node
    if current_token.is_increment? || current_token.is_decrement? || current_token.is_unary_operator?
      next_token!
      NodeUnary.new previous_token, unary_expression
    else
      postfix_expression
    end
  end

  private def postfix_expression : Node
    left_expr = primary_expression
    if current_token.is_increment? || current_token.is_decrement?
      next_token!
      NodeUnary.new previous_token, left_expr
    elsif current_token.is_left_square_bracket?
      operation = current_token
      next_token!
      right_expr = expression
      unless current_token.is_right_square_bracket?
        raise ParserException.new "Unexpected token '#{current_token.text}', expected ']'", current_token
      end
      next_token!
      NodeBinary.new left_expr, operation, right_expr
    elsif current_token.is_point? || current_token.is_arrow?
      operation = current_token
      next_token!
      if current_token.is_identificator?
        right_expr = NodeIdentificator.new current_token
      else
        raise ParserException.new "Unexpected token type '#{current_token.type}', expected 'identificator'", current_token
      end
      next_token!
      NodeBinary.new left_expr, operation, right_expr
    else
      left_expr
    end
  end

  private def primary_expression : Node
    node = if current_token.is_identificator?
      NodeIdentificator.new current_token
    elsif current_token.is_constant?
      NodeConstant.new current_token
    elsif current_token.is_string?
      NodeString.new current_token
    elsif current_token.is_left_bracket?
      next_token!
      expr = expression
      unless current_token.is_right_bracket?
        raise ParserException.new "Unexpected token '#{current_token.text}', expected ')'", current_token
      end
      expr
    else
      raise ParserException.new "Unexpected token '#{current_token.text}'", current_token
    end
    next_token!
    node
  end

  private def next_token! : Token
    @previous_token = @current_token
    @current_token = @next_token
    @next_token = scanner.next_token
  end
end