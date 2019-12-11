original_input = File.read('10-input').strip

example1 = <<END
.#..#
.....
#####
....#
...##
END

example2 = <<END
......#.#.
#..#.#....
..#######.
.#.#.###..
.#..#.....
..#....#.#
#..#....#.
.##.#..###
##...#..#.
.#....####
END

Map = Struct.new(:max_x, :max_y, :asteroids) do
  def best_asteroid
    pp asteroids.max_by { |a| a.los_size }
  end

  def inspect
    puts '  ' + (0..max_y).to_a.join(' ')
    (0..max_y).each do |y|
      print "#{y} "
      (0..max_x).each do |x|
        asteroid = asteroids.find { |a| a.x == x && a.y == y }

        if asteroid
          print "#{asteroid.los_size} "
        else
          print '. '
        end
      end
      puts
    end
    nil
  end

  def to_s
    ""
  end

  def calculate_loses
    asteroids.each do |asteroid|
      asteroid.los_size = los(asteroid.x, asteroid.y)
    end
  end

  def los(x, y)
    # puts "#{x} #{y}"
    asteroid = asteroids.find { |a| a.x == x && a.y == y }
    other_asteroids = (asteroids - [asteroid]).map(&:dup)

    other_asteroids.each do |other|
      dir_x = other.x - asteroid.x
      dir_y = other.y - asteroid.y
      dirs = [dir_x, dir_y].map(&:abs)
      gcd = dirs.min.gcd(dirs.max)
      dir_x = dir_x / gcd
      dir_y = dir_y / gcd
      xx = asteroid.x + dir_x
      yy = asteroid.y + dir_y
      # pp "(#{other.x}, #{other.y}): #{dir_x} #{dir_y} gcd: #{gcd}"
      found = false

      27.times do
        aa = other_asteroids.find { |a| a.x == xx && a.y == yy }
        if aa
          if found
            aa.in_los = false
          end
          found = true
        end
        xx += dir_x
        yy += dir_y
      end
    end

    other_asteroids.count { |oa| oa.in_los.nil?  }
  end
end

Asteroid = Struct.new(:x, :y, :los_size, :in_los) do
  def inspect
    "(#{x}, #{y}) #{in_los}"
  end
end

def load_map(input)
  map = Map.new input.lines.first.strip.size - 1, input.lines.size - 1, []

  input.each_line.each_with_index do |line, y|
    line.strip.split('').each_with_index do |sym, x|
      map.asteroids << Asteroid.new(x, y, 0) if sym == '#'
    end
  end

  map
end

map = load_map example1
map.calculate_loses
map.inspect
map.best_asteroid

map = load_map example2
map.calculate_loses
map.inspect
map.best_asteroid

map = load_map original_input
map.calculate_loses
map.inspect
map.best_asteroid
