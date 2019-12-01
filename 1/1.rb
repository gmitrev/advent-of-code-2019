input = File.read('1-input').each_line.map(&:to_i)

# 1
puts input.map { |l| l / 3 - 2 }.sum

# 2.1
res = input.map do |i|
  curr = i
  acc = []

  while curr > 0
    curr = curr / 3 - 2
    acc << curr if curr > 0
  end

  acc.sum
end.sum

puts res

# 2.2
acc = 0

while input.any?
  i = input.pop
  fuel = i / 3 - 2
  if fuel > 0
    acc += fuel
    input << fuel
  end
end

puts acc
