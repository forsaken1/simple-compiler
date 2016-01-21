require "./scanner"

class Tester
  TESTS_DIR = "tests"
  SCANNER_TESTS_DIR = "#{TESTS_DIR}/scanner"
  SCANNER_TEST_FILE_IN = "#{SCANNER_TESTS_DIR}/%s.in"
  SCANNER_TEST_FILE_OUT = "#{SCANNER_TESTS_DIR}/%s.out"

  def initialize
    @tests_count = 0
    
    scanner_test
    print_info
  end

  def scanner_test
    (1..100).each do |i|
      file_name = i < 10 ? "0#{i}" : i # файлы тестов начинаются с "0" для порядка
      if File.exists?(SCANNER_TEST_FILE_IN % file_name)
        if Scanner.new(SCANNER_TEST_FILE_IN % file_name).run.to_s == File.read(SCANNER_TEST_FILE_OUT % file_name)
          print '.'
        else
          print 'E'
        end
      else
        @tests_count = i - 1
        break
      end
    end
  end

  def print_info
    print "\nTests: #{@tests_count}\n"
  end
end

Tester.new