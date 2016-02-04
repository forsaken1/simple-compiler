class Parser
  def initialize(@scanner)
    @current_token = nil
    @ast = nil # abstract syntax tree
  end

  def run
    @ast = expression
  end

  def to_s
  end

  private def expression n = 0
    return unary_expression if n > 14
    case n of
    when 0: 
    end
    expression n - 1
  end

  private def unary_expression
    postfix_expression
  end

  private def postfix_expression
    primary_expression
  end

  private def primary_expression
    if @current_token.is_identificator?
      Node.new
    elsif @current_token.is_constant?
      Node.new
    elsif @current_token.is_string?
      Node.new
    elsif @current_token.is_left_bracket?
      expression
    else
    end    
  end

  private def next_token
    @current_token = @scanner.next_token
  end
end