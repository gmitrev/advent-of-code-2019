original_input = File.read('2-input').split(',').map(&:to_i)

def run_with_inputs(input, first, second)
  input[1] = first
  input[2] = second

  operator_index = 0

  loop do
    opcode = input[operator_index]
    target = input[operator_index + 3]

    get_input = ->(index, offset) { input[input[index + offset]] }

    case opcode
    when 1
      sum = get_input.(operator_index, 1) + get_input.(operator_index, 2)
      input[target] = sum
    when 2
      product = get_input.(operator_index, 1) * get_input.(operator_index, 2)
      input[target] = product
    when 99
      break
    end

    operator_index += 4
  end

  input[0]
end

puts "Answer 1: #{run_with_inputs(original_input.dup, 12, 2)}"

possible_pairs = (1..100).to_a.product((1..100).to_a)

possible_pairs.each_with_index do |pair, index|
  result = run_with_inputs(original_input.dup, pair[0], pair[1])

  if result == 19690720
    puts "Anwser 2: #{100 * pair[0] + pair[1]} for pair #{pair}"
    break
  end
end
