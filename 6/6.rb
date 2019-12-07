input = File.read('6-input').each_line.map(&:strip)

# input = %w[
#   B)C
#   C)D
#   D)E
#   E)F
#   B)G
#   COM)B
#   G)H
#   D)I
#   E)J
#   J)K
#   K)L
# ]

# input = %w[
# COM)B
# B)C
# C)D
# D)E
# E)F
# B)G
# G)H
# D)I
# E)J
# J)K
# K)L
# K)YOU
# I)SAN
# ]

Planet = Struct.new(:name, :parent) do
  def level
    @level ||=
      begin
        parent ? parent.level + 1 : 0
      end
  end

  def ancestors
    @ancestors ||=
      begin
        cursor = parent
        list = []

        while cursor
          list << cursor
          cursor = cursor.parent
        end

        list
      end
  end

  def distance_to(ancestor)
    ancestors.index(ancestor)
  end

  def has_ancestor?(node)
    ancestors.include? node
  end

  def inspect
    if parent
      "Planet #{name} orbits around #{parent.name}"
    else
      "Planet #{name} is the root planet"
    end
  end
end

planets = {}

input.each do |orbit|
  a, b = orbit.split(")")

  unless planets.key? a
    planets[a] = Planet.new(a, nil)
  end

  unless planets.key? b
    planets[b] = Planet.new(b, planets[a])
  else
    planets[b].parent = planets[a]
  end
end

puts "Anwser 1: #{planets.values.map(&:level).sum}"

you = planets['YOU']
san = planets['SAN']

puts "You: #{you.level}"
puts "SAN: #{san.level}"
root = planets.values.find { |p| p.parent == nil }

def find_last_common_ancestor(a, b)
  a.ancestors.each do |ancestor|
    if b.has_ancestor? ancestor
      puts "Found last common ancestor: #{ancestor}"
      return ancestor
    end
  end
end

last_common_ancestor = find_last_common_ancestor you, san

puts you.distance_to(last_common_ancestor) + san.distance_to(last_common_ancestor)

