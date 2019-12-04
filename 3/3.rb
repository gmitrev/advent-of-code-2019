input = File.read('3-input')

path1, path2 =  input.each_line.to_a.map { |line| line.split(',') }

# path1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72".split(',')
# path2 = "U62,R66,U55,R34,D71,R55,D58,R83".split(',')
#
# path1 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51".split(',')
# path2 = "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7".split(',')

# path1 = %w(R8 U5 L5 D3)
# path2 = %w(U7 R6 D4 L4)

def get_visited(paths)
  visited = {}
  x, y = 0, 0
  steps_x, steps_y = 0, 0

  paths.each do |path|
    direction = path[0]
    distance = path[1..-1].to_i

    until distance == 0
      case direction
      when 'U'
        x += 1
        steps_x +=1
      when 'D'
        x -= 1
        steps_x +=1
      when 'R'
        y += 1
        steps_y +=1
      when 'L'
        y -= 1
        steps_y +=1
      end

      distance -= 1

      visited[[x,y]] ||= steps_x + steps_y
    end
  end

  visited
end

visited_1 = get_visited(path1)
visited_2 = get_visited(path2)

intersections = (visited_1.keys & visited_2.keys)

distances = intersections.map do |x, y|
  x.abs + y.abs
end

puts "The closest out ot #{intersections.count} intersections is #{distances.min} steps away."

distances = intersections.map do |x, y|
  visited_1[[x,y]] + visited_2[[x,y]]
end

puts "The minimum out ot #{distances.count} intersections is #{distances.min} steps away."
