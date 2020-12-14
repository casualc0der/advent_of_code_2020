class GamesConsole
  def initialize(file)
    @data = File.read(file).split("\n").map do |d|
      line = d.split(' ')
      { instruction: line[0], move: line[1], visited: false }
    end
  end

    def game_loop(part = :part_1, data=@data)
      acc = 0
      index = 0
      while true
        return acc if index > data.size - 1
        line = data[index]
        return acc if line[:visited] == true && part == :part_1
        return false if line[:visited] == true && part == :part_2

        op = line[:move][0]
        amount = line[:move].tr("+-", "").to_i
        case line[:instruction]
        when 'nop'
          index += 1
        when 'acc'
          index += 1
          acc += amount if op == "+"
          acc -= amount if op == "-"
        when 'jmp'
          index += amount if op == "+"
          index -= amount if op == "-"
        end
        line[:visited] = true
      end
    end

    def loop_de_loop
      nop = @data.each_index.select {|i| @data[i][:instruction] == 'nop'}
      jmp = @data.each_index.select {|i| @data[i][:instruction] == 'jmp'}

      nop.each do |i|
        nop_to_jmp(i) == false ? next : nop_to_jmp(i)
      end
      jmp.each do |i|
        @data[i][:instruction] = 'nop'
        y = game_loop(:part_2, @data)
        if y == false
        @data[i][:instruction] = 'jmp'
        reset_data
        else
          return y
        end
      end
    end

    def reset_data
      @data.each do |d|
        d[:visited] = false
      end
    end

    private

    def nop_to_jmp(index)
        @data[index][:instruction] = 'jmp'
        x = game_loop(:part_2, @data)
        if x == false
          @data[index][:instruction] = 'nop'
          reset_data
          return false
        else
          return x
        end
    end
end
