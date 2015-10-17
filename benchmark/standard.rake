$:.unshift File.expand_path('../lib', __FILE__)

require 'hamlit'
require 'faml'
require 'yaml'

class Benchmark
  def self.bench
    start_time = Time.now
    yield
    Time.now - start_time
  end

  def self.ranking(*benchmarks)
    benchmarks = benchmarks.sort_by(&:total)

    base = benchmarks.first.total
    benchmarks.each do |bench|
      bench.report("%.2f" % (bench.total / base))
    end
  end

  attr_reader :total

  def initialize(name)
    @name  = name
    @total = 0.0
    @times = 0
    @max   = 0.0
  end

  def capture(result)
    @max   = result if @max < result
    @total += result
    @times += 1
  end

  def report(times)
    puts "[#{@name}] Count: #{@times}, Total: #{format(@total)}, Avg: #{format(@total / @times)}, Max: #{format(@max)} (#{times}x)"
  end

  private

  def format(seconds)
    "%.2fms" % (1000 * seconds)
  end
end

namespace :benchmark do
  desc 'Benchmark standard compilation'
  task :standard do
    haml_benchmark   = Benchmark.new('haml  ')
    faml_benchmark   = Benchmark.new('faml  ')
    hamlit_benchmark = Benchmark.new('hamlit')

    faml_engine   = Faml::Engine.new(filename: '')
    hamlit_engine = Hamlit::Engine.new

    haml             = File.read(File.expand_path('../test/templates/standard.haml', __dir__))
    locals           = {}
    options          = { ugly: true, escape_html: true }

    haml_time   = Benchmark.bench { Haml::Engine.new(haml, options).precompiled }
    faml_time   = Benchmark.bench { faml_engine.call(haml) }
    hamlit_time = Benchmark.bench { hamlit_engine.call(haml) }

    haml_benchmark.capture(haml_time)
    faml_benchmark.capture(faml_time)
    hamlit_benchmark.capture(hamlit_time)
    puts '# standard.haml compilation'
    Benchmark.ranking(haml_benchmark, faml_benchmark, hamlit_benchmark)
  end
end
task standard: 'benchmark:standard'