class SimpleCompilerException < Exception
  def with_info(@line, @pos)
    self
  end
end