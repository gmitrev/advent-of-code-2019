original_input = File.read('8-input').strip.split('').map(&:to_i)

x = 25
y = 6

layers = original_input.each_slice(25*6)

# Problem 1
result = layers.min_by { |l| l.count(0) }.then { |l| l.count(1) * l.count(2) }

puts "Answer 1: #{result}"

# Problem 2
def render(pixels, x:, y:)
  canvas = Array.new(x*y)

  pixels.to_a.reverse.each do |layer|
    layer.each_with_index do |pixel, index|
      canvas[index] = pixel unless pixel == 2
    end
  end

  canvas.each_slice(x) do |row|
    row.map { |p| p == 1 ? '▧' : ' ' }.each { |c| print c*3 }
    puts
    row.map { |p| p == 1 ? '▨' : ' ' }.each { |c| print c*3 }
    puts
  end
end

def animated_render(pixels, x:, y:)
  canvas = Array.new(x*y)
  pixels = pixels.to_a.reverse

  puts 'Answer 2:'

  pixels.each_with_index do |layer, i|
    layer.each_with_index do |pixel, index|
      canvas[index] = pixel unless pixel == 2
    end

    canvas.each_slice(x) do |row|
      row.map { |p| p == 1 ? '▧' : ' ' }.each { |c| print c*3 }
      puts
      row.map { |p| p == 1 ? '▨' : ' ' }.each { |c| print c*3 }
      puts
    end
    sleep 0.05
    print "\e[A\e[K" * 12 unless i.succ == pixels.size
  end

end

# render layers, x: 25, y: 6
animated_render layers, x: 25, y: 6
