require_relative 'intcode_runner'

original_input = File.read('7-input').split(',').map(&:to_i)
example1 = [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]
example2 = [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]
example3 = [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]

def run_with_amps(input, amp_configurations)
  results = amp_configurations.map do |config|
    o1 = IntcodeRunner.run(input, [config[0], 0])
    o2 = IntcodeRunner.run(input, [config[1], o1])
    o3 = IntcodeRunner.run(input, [config[2], o2])
    o4 = IntcodeRunner.run(input, [config[3], o3])
    o5 = IntcodeRunner.run(input, [config[4], o4])
    o5
  end

  puts "Results: #{results}"
  puts "Max: #{results.max}"
  results.max
end

def assert_equal(a, b, name)
  unless a == b
    raise "Unexpected result for #{name}. Expected: #{b}; Got: #{a}"
  end
end

# Example 1
max = run_with_amps(example1, [[4,3,2,1,0]])
expected = 43210
assert_equal(max, expected, 'Example 1')
# /Example 1

# Example 2
max = run_with_amps(example2, [[0,1,2,3,4]])
expected = 54321
assert_equal(max, expected, 'Example 2')
#/Example 2

# Example 3
max = run_with_amps(example3, [[1,0,4,3,2]])
expected = 65210
assert_equal(max, expected, 'Example 3')
#/Example 3

# Part 1
amp_configurations = [0,1,2,3,4].permutation.to_a
max = run_with_amps(original_input, amp_configurations)
# /Part 1
