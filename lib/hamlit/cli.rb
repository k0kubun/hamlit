require 'hamlit'
require 'thor'

module Hamlit
  class CLI < Thor
    desc 'render HAML', 'Render haml template'
    def render(file)
      code = generate_code(file)
      puts eval(code)
    end

    desc 'parse HAML', 'Show parse result'
    def parse(file)
      pp generate_ast(file)
    end

    private

    def generate_code(file)
      template = File.read(file)
      Hamlit::Engine.new.call(template)
    end

    def generate_ast(file)
      template = File.read(file)
      Hamlit::Parser.new.call(template)
    end

    # Flexible default_task, compatible with haml's CLI
    def method_missing(*args)
      return super(*args) if args.length > 1
      render(args.first.to_s)
    end

    # Enable colored pretty printing only for development environment.
    def pp(arg)
      require 'pry'
      Pry::ColorPrinter.pp(arg)
    rescue LoadError
      require 'pp'
      super(arg)
    end
  end
end