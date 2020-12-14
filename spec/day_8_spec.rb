require_relative '../day_8/day_8'

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
    skip 'all ok'
      file = Tempfile.new
      file.write('hello')
      file.flush

      games_console = GamesConsole.new(file)

      expect(games_console.data).not_to be_empty

    end

    it 'can split the file into chunks' do
      skip 'all ok'

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

=begin
  context 'part 1' do
    describe 'game_loop' do
      it 'can return the correct answer for smol list' do
      file = Tempfile.new
      file.write(test_data)
      file.flush

      games_console = GamesConsole.new(file)

      expect(games_console.game_loop).to eq(5)

      end
      it 'can return the correct answer for full list' do
      path = File.expand_path(File.dirname(__FILE__) + "/game_loop.txt")
      games_console = GamesConsole.new(path)

      expect(games_console.game_loop).to eq(1654)

      end
    end
  end
=end
  context 'part 2' do
    describe 'loop_de_loop' do
      it 'can return the correct answer for smol list' do
      file = Tempfile.new
      file.write(test_data)
      file.flush

      games_console = GamesConsole.new(file)

      expect(games_console.loop_de_loop).to eq(8)

      end

      it 'can return the correct answer for full list' do
      path = File.expand_path(File.dirname(__FILE__) + "/game_loop.txt")
      games_console = GamesConsole.new(path)

      expect(games_console.loop_de_loop).to eq(833)

      end
    end
  end
end
