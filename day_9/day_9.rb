class PortCracker
  attr_reader :data
  def initialize(file)
    @data = File.read(file).split("\n").map(&:to_i)
  end
  def part_1(p)
    preamble_size = p
    n = preamble_size
    i = 0
    while n < data.size
      slice = data[i...n]
      check = data[n]
      return check unless checker?(slice, check)
      i += 1
      n += 1
    end
  end

  def part_2(target)
    i = 0
    n = 1
    while true
      slice = data[i..n]
      return slice.min + slice.max if slice.sum == target
      if slice.sum > target
        i += 1
        n = i + 1
      else
        n += 1
      end
    end
  end

  def checker?(arr, num)
    arr.combination(2).to_a.each do |check|
      return true if check.sum == num
    end
    false
  end
end

