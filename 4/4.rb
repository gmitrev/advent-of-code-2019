password_range = 123257..647015

def huh?(num)
  increasing = []
  repeating_numbers = {}

  num.digits.each_cons(2).each do |a, b|
    increasing << (a >= b)

    if a == b
      repeating_numbers[a] = repeating_numbers[a].to_i + 1
    end
  end

  # 1
  increasing.all? && repeating_numbers.any?

  # 2
  increasing.all? && repeating_numbers.values.any? { |v| v == 1 }
end

nums = password_range.select do |n|
  huh? n
end

puts nums.count
