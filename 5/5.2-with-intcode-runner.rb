original_input = File.read('5-input').split(',').map(&:to_i)
require_relative '../7/intcode_runner'

puts IntcodeRunner.run(original_input.dup, [5], log_level: Logger::DEBUG)
