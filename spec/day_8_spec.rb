require 'pry'
class GamesConsole
  attr_reader :data
  def initialize(file)
    @data = File.read(file).split("\n").map do |d|
      line = d.split(' ')
      { instruction: line[0], move: line[1], visited: false }
    end

    def loop
      acc = 0
      index = 0
      while true
        line = data[index]
        return acc if line[:visited] == true

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
  end
end


require 'tempfile'
RSpec.describe 'Handheld Halting' do
  let(:test_data) {<<~FILE
                    nop +0
                    acc +1
                    jmp +4
                    acc +3
                    jmp -3
                    acc -99
                    acc +1
                    jmp -4
                    acc +6

FILE

}
  describe 'setup' do
    it 'can open a file to be read' do
      file = Tempfile.new
      file.write('hello')
      file.flush

      games_console = GamesConsole.new(file)

      expect(games_console.data).not_to be_empty

    end

    it 'can split the file into chunks' do

      file = Tempfile.new
      file.write(test_data)
      file.flush

      expected = [
        {instruction: 'nop', move: '+0', visited: false},
        {instruction: 'acc',move: '+1', visited: false },
        {instruction: 'jmp', move: '+4', visited: false },
        {instruction: 'acc',move:  '+3', visited: false},
        {instruction: 'jmp',move:  '-3', visited: false },
        {instruction: 'acc',move:  '-99', visited: false },
        {instruction: 'acc',move:  '+1', visited: false },
        {instruction: 'jmp',move:  '-4' , visited: false},
        {instruction: 'acc',move:  '+6' , visited: false},
      ]
      games_console = GamesConsole.new(file)

      expect(games_console.data).to eq(expected)
    end
  end

  context 'part 1' do
    describe 'loop' do
      it 'can return the correct answer for smol list' do
      file = Tempfile.new
      file.write(test_data)
      file.flush

      games_console = GamesConsole.new(file)

      expect(games_console.loop).to eq(5)

      end
      it 'can return the correct answer for full list' do
      path = File.expand_path(File.dirname(__FILE__) + "/game_loop.txt")
      games_console = GamesConsole.new(path)

      expect(games_console.loop).to eq(1654)

      end
    end
  end

end
