original_input = File.read('12-input')

input = <<~END
<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>
END

input2 = <<~END
<x=-8, y=-10, z=0>
<x=5, y=5, z=10>
<x=2, y=-7, z=3>
<x=9, y=-8, z=-3>
END

System = Struct.new(:planets) do
  def inspect
    puts planets.map(&:to_s)
  end

  def cycle(i=nil)
    # puts "After #{i+1} steps:" if i
    planets.each do |planet|
      other_planets = planets - [planet]

      other_planets.each do |p|
        planet.vel_x_will_change += p.x <=> planet.x
        planet.vel_y_will_change += p.y <=> planet.y
        planet.vel_z_will_change += p.z <=> planet.z
      end
    end

    planets.each do |planet|
      planet.vel_x = planet.vel_x_will_change
      planet.vel_y = planet.vel_y_will_change
      planet.vel_z = planet.vel_z_will_change

      planet.x += planet.vel_x
      planet.y += planet.vel_y
      planet.z += planet.vel_z
      # puts planet
    end
    # puts
  end

  def total_energy
    planets.sum(&:total)
  end
end

Planet = Struct.new(:x, :y, :z, :vel_x, :vel_y, :vel_z, :vel_x_will_change, :vel_y_will_change, :vel_z_will_change) do
  def potential
    x.abs + y.abs + z.abs
  end

  def kinetic
    vel_x.abs + vel_y.abs + vel_z.abs
  end

  def total
    potential * kinetic
  end

  def to_s
    size = 3
    "pos=<x=#{x.to_s.rjust(size)}, y=#{y.to_s.rjust(size)}, z=#{z.to_s.rjust(size)}>, vel=<x=#{vel_x.to_s.rjust(size)}, y=#{vel_y.to_s.rjust(size)}, z=#{vel_z.to_s.rjust(size)}>"
  end
end

# # Example 1
# system = System.new([])
#
# input.each_line do |planet|
#   match = planet.strip.match(/<x=(?<x>.*), y=(?<y>.*), z=(?<z>.*)>/)
#   system.planets << Planet.new(match[:x].to_i, match[:y].to_i, match[:z].to_i, 0, 0, 0, 0, 0, 0)
# end
#
# puts 'After 0 steps:'
# system.inspect
# puts
#
# 100.times do |i|
#   system.cycle i
# end
#
# puts 'After 100 steps:'
# system.inspect
# puts
#
# # Example 2
# system = System.new([])
#
# input2.lines.to_a.map do |planet|
#   match = planet.strip.match(/<x=(?<x>.*), y=(?<y>.*), z=(?<z>.*)>/)
#   system.planets << Planet.new(match[:x].to_i, match[:y].to_i, match[:z].to_i, 0, 0, 0, 0, 0, 0)
# end
#
# puts 'After 0 steps:'
# system.inspect
# puts
#
# 100.times do |i|
#   system.cycle i
# end
#
# puts 'After 100 steps:'
# system.inspect
# puts
#
# Real
system = System.new([])

original_input.lines.to_a.map do |planet|
  match = planet.strip.match(/<x=(?<x>.*), y=(?<y>.*), z=(?<z>.*)>/)
  system.planets << Planet.new(match[:x].to_i, match[:y].to_i, match[:z].to_i, 0, 0, 0, 0, 0, 0)
end

puts 'After 0 steps:'
system.inspect
puts

1000.times do |i|
  system.cycle i
end

puts 'After 1000 steps:'
system.inspect
puts

puts system.total_energy
