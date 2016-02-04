require "./src/scanner"
require "./src/parser"

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
      elsif @flag == "-p"
        Parser.new(Scanner.new(@file_path)).run.to_s
      end
    end
  end
end

puts SimpleCompiler.new.run