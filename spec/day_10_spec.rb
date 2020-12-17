# frozen_string_literal: true

require 'pry'
class Adapter
  attr_reader :data

  def initialize(file)
    @data = File.read(file).split("\n").map(&:to_i).sort.unshift(0)
  end

  def part_1
    one_diff = 0
    three_diff = 0

    data.each_with_index do |a, i|
      if i == data.size - 1
        three_diff += 1
        break
      end
      one_diff += 1 if diff_checker(a, i) == 1
      three_diff += 1 if diff_checker(a, i) == 3
    end
    one_diff * three_diff
  end

  private

  def diff_checker(a, i)
    return 1 if data[i + 1] - a == 1
    return 3 if data[i + 1] - a == 3
  end
end

require 'tempfile'

RSpec.describe Adapter do
  subject { Adapter.new(file) }

  let(:file) { Tempfile.new }
  let(:input) { "5\n2\n1\n4\n3\n" }

  context 'setup creates a sorted array containing the data' do
    before do
      file.write(input)
      file.flush
    end
    it { expect(subject.data).not_to be_empty }
    it { expect(subject.data).to eq([0, 1, 2, 3, 4, 5]) }
  end

  context 'part 1 finds the differences between the adapters small list' do
    let(:input_2) { "16\n10\n15\n5\n1\n11\n7\n19\n6\n12\n4\n" }
    before do
      file.write(input_2)
      file.flush
    end
    it { expect(subject.data).to eq([0, 1, 4, 5, 6, 7, 10, 11, 12, 15, 16, 19]) }
    it { expect(subject.part_1).to eq(7 * 5) }
  end

  context 'part 1 finds the differences between the adapters bigger list' do
    let(:input_3) { "28\n33\n18\n42\n31\n14\n46\n20\n48\n47\n24\n23\n49\n45\n19\n38\n39\n11\n1\n32\n25\n35\n8\n17\n7\n9\n4\n2\n34\n10\n3\n" }
    before do
      file.write(input_3)
      file.flush
    end
    it { expect(subject.part_1).to eq(22 * 10) }
  end

  context 'part 1 finds the differences between the adapters full list' do
    let(:file) { File.expand_path("#{File.dirname(__FILE__)}/jolts.txt") }
    it { expect(subject.part_1).to eq(1820) }
  end
end
