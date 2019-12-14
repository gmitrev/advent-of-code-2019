require_relative 'intcode_runner'

input = File.read('13-input').split(',').map(&:to_i)

runner = IntcodeRunner.new input

max_x = 43
max_y = 22

board = max_y.times.map do
  Array.new(max_x)
end

def output(board, score)
  max_x = board.first.size - 1
  max_y = board.size - 1

  puts "SCORE: #{score}"
  (0..max_y).each do |y|
    (0..max_x).each do |x|
      tile = board[y][x]

      symbol =
        case tile
        when 0 then ' '
        # when 1 then '-'
        when 1 then '░'
        # when 2 then '▧'
        when 2 then '▣'
        when 3 then '⏄'
        when 3 then '_'
        when 4 then '⚈'
        when 4 then '.'
        end
      print symbol
    end
    puts
  end
end

# Part 1
# output = runner.run
# output.each_slice(3) do |slice|
#   x, y, tile = slice
#
#   board[y][x] = tile
# end

# puts board.flatten.count { |r| r == 2 }
# /Part 1

score = 0
playing = false
runner.instructions[0] = 2
ball_movements = 0
paddle_x = 0
ball_x = 0
frames = 0

loop do
  troika = runner.start
  skip = false

  if troika.empty?
    puts "Game over! Score: #{score}. Ball movements: #{ball_movements}. Frames: #{frames}"
    ended = true
    break
  end

  x, y, tile = troika

  skip = true if tile == 0

  if tile == 3
    paddle_x = x
  end

  if tile == 4
    ball_movements += 1
    ball_x = x

    runner.feed_input ball_x <=> paddle_x
  end

  if playing == false && ball_movements > 1
    playing = true
  end

  if x == -1 && y == 0 && tile != 0
    score = tile
  end

  board[y][x] = tile
  frames += 1

  if playing && !skip # && frames % 100 == 0
    print "\e[A\e[K" * 26
    output board, score
    sleep 0.021
  end
end
