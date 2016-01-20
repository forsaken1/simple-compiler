require "./scanner"

class Tester
  TESTS_DIR = "tests"
  SCANNER_TESTS_DIR = "#{TESTS_DIR}/scanner"
  SCANNER_TEST_FILE_IN = "#{SCANNER_TESTS_DIR}/%s.in"
  SCANNER_TEST_FILE_OUT = "#{SCANNER_TESTS_DIR}/%s.out"

  def initialize
    scanner_test
  end

  def scanner_test
    (1..100).each do |i|
      if File.exists?(SCANNER_TEST_FILE_IN % i)
        if Scanner.new(SCANNER_TEST_FILE_IN % i).run == File.read(SCANNER_TEST_FILE_OUT % i)
          puts '.'
        else
          puts 'E'
        end
      else
        break
      end
    end
  end
end

Tester.new