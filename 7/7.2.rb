require_relative 'intcode_runner'

original_input = File.read('7-input').split(',').map(&:to_i)
example1 = [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26, 27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5]
example2 = [3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54, -5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10]

def run_with_amps(input, amp_configurations)
  results = amp_configurations.map do |amp_config|
    amp_a = IntcodeRunner.new(input.dup, [amp_config[0], 0])
    amp_b = IntcodeRunner.new(input.dup, [amp_config[1]])
    amp_c = IntcodeRunner.new(input.dup, [amp_config[2]])
    amp_d = IntcodeRunner.new(input.dup, [amp_config[3]])
    amp_e = IntcodeRunner.new(input.dup, [amp_config[4]])

    until amp_e.halted?
      amp_a.start

      amp_b.feed_input amp_a.output
      amp_b.start

      amp_c.feed_input amp_b.output
      amp_c.start

      amp_d.feed_input amp_c.output
      amp_d.start

      amp_e.feed_input amp_d.output
      amp_e.start

      amp_a.feed_input amp_e.output
    end
    amp_e.output
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
max = run_with_amps(example1, [[9,8,7,6,5]])
expected = 139629729
assert_equal(max, expected, 'Example 1')
# /Example 1

# Example 2
max = run_with_amps(example2, [[9,7,8,5,6]])
expected = 18216
assert_equal(max, expected, 'Example 2')
#/Example 2

# Part 2
amp_configurations = [5,6,7,8,9].permutation.to_a
max = run_with_amps(original_input, amp_configurations)
# /Part 2
