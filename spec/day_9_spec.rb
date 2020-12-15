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


require 'tempfile'
RSpec.describe 'Encoding Error' do
  let(:test_data) { <<~DATA
                    35
                    20
                    15
                    25
                    47
                    40
                    62
                    55
                    65
                    95
                    102
                    117
                    150
                    182
                    127
                    219
                    299
                    277
                    309
                    576
                    DATA
}
  context 'setup' do

    subject { PortCracker.new(file).data }
    let(:file) { Tempfile.new }

    it { is_expected.to eq []}

    it {
      file.write('hello')
      file.flush
      is_expected.not_to be_empty
       }


    it 'can format the data correctly' do
      file.write(test_data)
      file.flush

      expected = [
          35,
          20,
          15,
          25,
          47,
          40,
          62,
          55,
          65,
          95,
          102,
          117,
          150,
          182,
          127,
          219,
          299,
          277,
          309,
          576,
      ]
      expect(subject).to eq(expected)

    end

  end
    context 'part_1' do
    it 'calculates the correct number to break on with test data' do
      file = Tempfile.new
      file.write(test_data)
      file.flush
      port_cracker = PortCracker.new(file)

      expect(port_cracker.part_1(5)).to eq(127)
    end
    it 'calculates the number to break on with real data' do
      path = File.expand_path(File.dirname(__FILE__) + "/encoding.txt")

      port_cracker = PortCracker.new(path)

      expect(port_cracker.part_1(25)).to eq(776203571)
    end
    end

    context 'part_2' do
    it 'calculates the correct number to break on with test data' do
      file = Tempfile.new
      file.write(test_data)
      file.flush
      port_cracker = PortCracker.new(file)

      expect(port_cracker.part_2(port_cracker.part_1(5))).to eq(62)
    end
    it 'calculates the number to break on with real data' do
      path = File.expand_path(File.dirname(__FILE__) + "/encoding.txt")
      port_cracker = PortCracker.new(path)
      expect(port_cracker.part_2(port_cracker.part_1(25))).to eq(62)
    end

    end
end
