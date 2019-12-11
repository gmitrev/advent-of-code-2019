require_relative 'intcode_runner'

input = File.read('11-input').split(',').map(&:to_i)

def run(input, initial=0)
  size = 100

  board = size.times.map do
    Array.new(size)
  end

  x, y = size/2, size/2

  runner = IntcodeRunner.new input
  direction = :north

  until runner.halted? do
    cur = board[y][x] || initial

    runner.set_input cur

    paint, turn = runner.start

    board[y][x] = paint

    direction =
      case turn
      when 0
        case direction
        when :north then :west
        when :west  then :south
        when :south then :east
        when :east  then :north
        end
      when 1
        case direction
        when :north then :east
        when :west  then :north
        when :south then :west
        when :east  then :south
        end
      end

    case direction
    when :north
      y -= 1
    when :south
      y += 1
    when :west
      x -= 1
    when :east
      x += 1
    end
  end

  board
end

# Part 1
puts run(input.dup, 0).flatten.count { |x| x != nil }
# /Part 1

# Part 2
def output(board)
  max_x = board.first.size - 1
  max_y = board.size - 1

  (0..max_y).each do |y|
    (0..max_x).each do |x|
      panel = board[y][x]

      panel == 1 ? print('0') : print('.')
    end
    puts
  end
end

output run(input.dup, 1)
# /Part 2
