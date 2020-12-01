class Report
  attr_reader :data

  def initialize(file)
    @data = File.read(file).split("\n").map(&:to_i)
  end

  # very slow, but easy to implement ;)
  def parse(num_of_entries)
      @data.permutation(num_of_entries)
           .select {|x| x.sum == 2020}
           .map(&:sort)
           .uniq
           .flatten(1)
           .inject(:*)
  end
end
