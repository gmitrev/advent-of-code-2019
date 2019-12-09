require_relative 'intcode_runner'

input = File.read('9-input').split(',').map(&:to_i)
example_input1 = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
example_input2 = [1102,34915192,34915192,7,4,7,99,0]
example_input3 = [104,1125899906842624,99]

def assert_equal(a, b, name)
  unless a == b
    raise "Unexpected result for #{name}. Expected: #{b}; Got: #{a}"
  end
end

# Example 1
example1 = IntcodeRunner.new(example_input1)
example1.run
assert_equal(example1.output.compact, example_input1, 'Example 1')
# /Example 1

# # Example 2
example2 = IntcodeRunner.new(example_input2)
example2.run
assert_equal(example2.output.first, 1219070632396864, 'Example 2')
# #/Example 2
#
# # Example 3
example3 = IntcodeRunner.new(example_input3)
example3.run
assert_equal(example3.output.first, example_input3[1], 'Example 3')
# #/Example 3

# Part 1
part1 = IntcodeRunner.new(input, [1])
pp part1.run
# # /Part 1

# Part 2
part2 = IntcodeRunner.new(input, [2])
pp part2.run
# # /Part 2
