require 'atcoder_greedy'
require 'atcoder_greedy/command'
require 'diff/lcs'
require 'tempfile'

module AtcoderGreedy
  class Command < Thor
    desc 'test PROBLEM', 'test your solution'

    def test(problem_name)
      TestCase.new(problem_name).validate
    end
  end

  class TestCase
    def initialize(problem_name)
      @input_file = File.open("./input_#{problem_name}.txt", 'r')
      @exec_file = "./#{problem_name}.rb"
      get_in_out
    end

    def get_in_out
      i = 0
      @input = []
      @output = []
      now = nil
      while (t = @input_file.gets) != nil
        example_string = "-- Example #{i}"
        answer_string = "-- Answer #{i}"

        if t.chomp == example_string
          now.close(false) unless now.nil?
          now = Tempfile.new(['in', '.txt'], './')
          @input.push(now)
          now.open
        elsif t.chomp == answer_string
          now.close(false) unless now.nil?
          now = Tempfile.new(['out', '.txt'], './')
          @output.push(now)
          now.open
          i += 1
        else
          now.puts t
        end
      end
      @input[-1].close(false)
      @output[-1].close(false)
    end

    def validate
      @input.size.times do |j|
        myout_file = Tempfile.new(['myout', '.txt'], './')
        myout_file.open
        pid = Process.fork do
          exec "ruby #{@exec_file} < #{@input[j].path} > #{myout_file.path}"
          @input[j].close
          myout_file.close(false)
        end
        Process.waitpid pid

        myout = myout_file.open.read
        myout_file.close
        correct = File.open("#{@output[j].path}").read
        diffs = Diff::LCS.diff(myout, correct)
        if diffs.size == 0
          puts "Testcase ##{j} ... PASSED!"
        else
          puts "Testcase ##{j} ... FAILED!"
          puts "Your Output:"
          puts "#{myout}"
          puts "Correct Answer:"
          puts "#{correct}"
        end
      end
    end
  end
end
