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
    @ast.to_s(0, true)
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
    left_expr = conditional_expression
    right_expr = uninitialized Node
    operation = uninitialized Token
    if current_token.is_assignment_operator?
      operation = current_token
      next_token!
      right_expr = assignment_expression
      raise ParserException.new("Assignment expression without right operand", current_token) if right_expr.nil?
      NodeBinary.new left_expr, operation, right_expr
    else
      left_expr
    end
  end

  private def conditional_expression : Node
    condition = binary_expression
    if current_token.is_question?
      next_token!
      if_true = expression
      if current_token.is_colon?
        next_token!
        if_false = conditional_expression
      else
        raise ParserException.new "Unexpected token '#{current_token.text}', expected ':'", current_token
      end
      NodeIf.new condition, if_true, if_false
    else
      condition
    end
  end

  private def binary_expression(priority = 0) : Node
    return cast_expression if priority > 10
    left_expr = binary_expression priority + 1
    delete_left_recursion priority, left_expr
  end

  private def delete_left_recursion(priority : Int32, left_expr : Node)
    return left_expr unless current_token.is_binary_operation?
    operation = current_token
    next_token!
    right_expr = binary_expression priority + 1
    raise ParserException.new("Binary expression without right operand", current_token) if right_expr.nil?
    delete_left_recursion priority, NodeBinary.new(left_expr, operation, right_expr)
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
      Node.new
      #raise ParserException.new "Unexpected token '#{current_token.text}'", current_token
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