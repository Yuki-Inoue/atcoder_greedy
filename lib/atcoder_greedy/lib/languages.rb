class Languages
  ALL_LANGUAGES = %w[rb cpp c hs].freeze
  def initialize(solve_file)
    @solve_file = solve_file
  end

  def compile(_problem_name)
    raise 'Error: Not Implemented'
  end

  def execute(_input_path, _output_path)
    raise 'Error: Not Implemented'
  end
end

class Rb < Languages
  def compile(_problem_name)
    true
  end

  def execute(input_path, output_path)
    system "ruby #{@solve_file} < #{input_path} > #{output_path}"
  end
end

class Cpp < Languages
  def compile(problem_name)
    @exec_file = "#{problem_name}.out"
    system "g++ #{@solve_file} -o #{problem_name}.out"
  end

  def execute(input_path, output_path)
    system "./#{@exec_file} < #{input_path} > #{output_path}"
  end
end

class C < Languages
  def compile(problem_name)
    @exec_file = "#{problem_name}.out"
    system "gcc #{@solve_file} -o #{problem_name}.out"
  end

  def execute(input_path, output_path)
    system "./#{@exec_file} < #{input_path} > #{output_path}"
  end
end

class Hs < Languages
  def compile(problem_name)
    @exec_file = "#{problem_name}.out"
    system "ghc #{@solve_file} -o #{problem_name}.out"
  end

  def execute(input_path, output_path)
    system "./#{@exec_file} < #{input_path} > #{output_path}"
  end
end
