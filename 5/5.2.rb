original_input = File.read('5-input').split(',').map(&:to_i)

# puts original_input.inspect

def dump(instructions)
  instructions.take(250).each_with_index do |i, index|
    puts "#{index}: #{i}"
  end
end

def run_with_inputs(instructions, input)
  operator_index = 0
  output = []
  stop = false

  advance = ->(with) { operator_index += with }
  set_index = ->(to) { operator_index = to }

  until stop do
    puts '=' *40
    opcode = instructions[operator_index]
    puts "##{operator_index}"
    puts opcode

    get_parameter = ->(index, offset) { instructions[instructions[index + offset]] }
    get_immediate = ->(index, offset) { instructions[index + offset] }

    code_1 = ->(a, b, target, adv=0) {
      sum = a + b
      puts "writing sum of #{a}+#{b} #{sum} to ##{target}"
      instructions[target] = sum
      advance.(4)
    }

    code_2 = ->(a, b, target, adv=0) {
      product = a * b
      puts "writing product #{a}*#{b} #{product} to ##{target}"
      instructions[target] = product
      advance.(4)
    }

    code_3 = ->(address, adv=0) {
      puts "writing #{input} to ##{address}"
      instructions[address] = input
      advance.(2)
    }

    code_4 = ->(val, adv=0) {
      output << val

      if val != 0
        stop = true
      end
      puts "output: #{val}"
      advance.(2)
    }

    code_5 = ->(a, b) {
      puts "Comparing #{a} != #{0}"
			if a != 0
        puts "Setting index to #{b}"
        set_index.(b)
      else
        puts "Advancing by 3"
        advance.(3)
      end
    }

    code_6 = ->(a, b) {
      puts "Comparing #{a} == #{0}"
			if a == 0
        puts "Setting index to #{b}"
        set_index.(b)
      else
        puts "Advancing by 3"
        advance.(3)
      end
    }

    code_7 = ->(a, b, t) {
      puts "Comparing if #{a} < #{b}"
      if a < b
        puts "Setting #{t} to 1"
        instructions[t] = 1
      else
        puts "Setting #{t} to 0"
        instructions[t] = 0
      end

      puts "Advancing by 4"
      advance.(4)
    }

    code_8 = ->(a, b, t) {
      puts "Comparing if #{a} == #{b}"
      if a == b
        puts "Setting #{t} to 1"
        instructions[t] = 1
      else
        puts "Setting #{t} to 0"
        instructions[t] = 0
      end
      puts "Advancing by 4"
      advance.(4)
    }

    code_big = ->() {
      new_opcode, _, *modes = opcode.digits
      puts "Opcode: #{new_opcode}"
      puts "Modes: #{modes}"
      mode_a, mode_b, mode_t = modes
      puts "mode_a: #{mode_a}, mode_b: #{mode_b}, mode_t: #{mode_t}"

      a = mode_a.to_i == 1 ?
        get_immediate.(operator_index, 1) :
        get_parameter.(operator_index, 1)

      b = mode_b.to_i == 1 ?
        get_immediate.(operator_index, 2) :
        get_parameter.(operator_index, 2)

      t = get_immediate.(operator_index, 3)

      puts "a: #{a}; b: #{b}; t: #{t}"

      case new_opcode
      when 1
        code_1.(a, b, t, 0)
      when 2
        code_2.(a, b, t, 0)
      when 3
        code_3.(a, 0)
      when 4
        code_4.(a, 0)
      when 5
        code_5.(a, b)
      when 6
        code_6.(a, b)
      when 7
        code_7.(a, b, t)
      when 8
        code_8.(a, b, t)
      when 99
        raise "KOR"
      else
        puts "OUTPUT: #{output}"

        dump(instructions)
        raise "MEGA KOR: #{new_opcode}"
      end
    }

    case opcode
    when 1
      a = get_parameter.(operator_index, 1)
      b = get_parameter.(operator_index, 2)
      target = get_immediate.(operator_index, 3)
      code_1.(a, b, target)
    when 2
      a = get_parameter.(operator_index, 1)
      b = get_parameter.(operator_index, 2)
      target = get_immediate.(operator_index, 3)
      code_2.(a, b, target)
    when 3
      address = get_immediate.(operator_index, 1)
      code_3.(address)
    when 4
      value = get_parameter.(operator_index, 1)
      code_4.(value)
    when 5
      a = get_parameter.(operator_index, 1)
      b = get_parameter.(operator_index, 2)
      code_5.(a, b)
    when 6
      a = get_parameter.(operator_index, 1)
      b = get_parameter.(operator_index, 2)
      code_6.(a, b)
    when 7
      a = get_parameter.(operator_index, 1)
      b = get_parameter.(operator_index, 2)
      t = get_immediate.(operator_index, 3)
      code_7.(a, b, t)
    when 8
      a = get_parameter.(operator_index, 1)
      b = get_parameter.(operator_index, 2)
      t = get_immediate.(operator_index, 3)
      code_8.(a, b, t)
    when 99
      break
    else
      code_big.()
    end

  end

  dump(instructions)
  output
end

puts run_with_inputs(original_input.dup, 5)
