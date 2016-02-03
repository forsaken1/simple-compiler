require "./src/scanner"

class SimpleCompiler
  def initialize
    @arguments = ARGV
    @flag = @arguments[0]
    @file_path = @arguments[1]
  end

  def run
    if @arguments.size == 2
      if @flag == "-s"
        Scanner.new(@file_path).run.to_s
      end
    end
  end

  private def flag
    @flag ||= find_flag
  end

  private def find_flag
  end
end

puts SimpleCompiler.new.run