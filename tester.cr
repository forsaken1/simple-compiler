class Tester
  DEBUG = true

  TESTS_DIR = "tests"
  SCANNER_TESTS_DIR = "#{TESTS_DIR}/scanner"
  PARSER_TESTS_DIR = "#{TESTS_DIR}/parser"

  def initialize
    @tests_count, @fail_tests_count, @success_tests_count = 0, 0, 0
    @debug_info = ""
  end

  def run
    build_compiler
    scanner_tests
    parser_tests
    print_info
  rescue ex : Exception
    puts ex.message
  end

  private def run_tests(range, directory)
    (range).each do |i|
      file_name = i < 10 ? "0#{i}" : i
      in_file = "#{directory}/#{file_name}.in"
      out_file = "#{directory}/#{file_name}.out"
      if File.exists?(in_file)
        output = yield in_file
        true_output = File.read(out_file)
        if output == true_output
          print '.'
          @success_tests_count += 1
        else
          print 'E'
          @fail_tests_count += 1
          debug { @debug_info += "\nin file #{out_file}:\nget:\n#{output}\n\nexpected:\n#{true_output}\n" }
        end
        @tests_count += 1
      else
        break
      end
    end
  end

  private def parser_tests
    run_tests 1..14, PARSER_TESTS_DIR do |file|
      `./simple-compiler -p #{file}`
    end
  end

  private def scanner_tests
    run_tests 1..60, SCANNER_TESTS_DIR do |file|
      `./simple-compiler -s #{file}`
    end
  end

  private def print_info
    print @debug_info
    print "\nTests: #{@tests_count}\t success: #{@success_tests_count}\t fails: #{@fail_tests_count}\n"
  end

  private def debug
    yield if DEBUG
  end

  private def build_compiler
    build_info = `crystal build simple-compiler.cr`
    if build_info != ""
      raise Exception.new build_info
    end
  end
end

Tester.new.run