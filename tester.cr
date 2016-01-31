require "./scanner"

class Tester
  DEBUG = true

  TESTS_DIR = "tests"
  SCANNER_TESTS_DIR = "#{TESTS_DIR}/scanner"
  SCANNER_TEST_FILE_IN = "#{SCANNER_TESTS_DIR}/%s.in"
  SCANNER_TEST_FILE_OUT = "#{SCANNER_TESTS_DIR}/%s.out"

  def initialize
    @tests_count = 0
    @fail_tests_count = 0
    @success_tests_count = 0
    
    scanner_test
    print_info
  end

  def scanner_test
    (1..35).each do |i|
      file_name = i < 10 ? "0#{i}" : i # файлы тестов начинаются с "0" для порядка
      if File.exists?(SCANNER_TEST_FILE_IN % file_name)
        in_file = SCANNER_TEST_FILE_IN % file_name
        out_file = SCANNER_TEST_FILE_OUT % file_name
        output = Scanner.new(in_file).run.to_s
        true_output = File.read(out_file)
        if output == true_output
          print '.'
          @success_tests_count += 1
        else
          print 'E'
          @fail_tests_count += 1
          debug { puts "\nget:\n#{output.to_readable_format}\n\nexpected:\n#{true_output.to_readable_format}\n\nin file: #{out_file}\n" }
        end
        @tests_count += 1
      else
        break
      end
    end
  end

  def print_info
    print "\nTests: #{@tests_count}\t success: #{@success_tests_count}\t fails: #{@fail_tests_count}\n"
  end

  def debug
    yield if DEBUG
  end
end

Tester.new