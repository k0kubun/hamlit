# frozen_string_literal: true
require_relative "filters/base.rb"
require_relative "filters/text_base.rb"
require_relative "filters/tilt_base.rb"
require_relative "filters/coffee.rb"
require_relative "filters/css.rb"
require_relative "filters/erb.rb"
require_relative "filters/escaped.rb"
require_relative "filters/javascript.rb"
require_relative "filters/less.rb"
require_relative "filters/markdown.rb"
require_relative "filters/plain.rb"
require_relative "filters/preserve.rb"
require_relative "filters/ruby.rb"
require_relative "filters/sass.rb"
require_relative "filters/scss.rb"
require_relative "filters/cdata.rb"

module Hamlit
  class Filters
    @registered = {}

    class << self
      attr_reader :registered

      def remove_filter(name)
        registered.delete(name.to_s.downcase.to_sym)
        if constants.map(&:to_s).include?(name.to_s)
          remove_const name.to_sym
        end
      end

      private

      def register(name, compiler)
        registered[name] = compiler
      end
    end

    register :coffee,       Coffee
    register :coffeescript, CoffeeScript
    register :css,          Css
    register :erb,          Erb
    register :escaped,      Escaped
    register :javascript,   Javascript
    register :less,         Less
    register :markdown,     Markdown
    register :plain,        Plain
    register :preserve,     Preserve
    register :ruby,         Ruby
    register :sass,         Sass
    register :scss,         Scss
    register :cdata,        Cdata

    def initialize(options = {})
      @options = options
      @compilers = {}
    end

    def compile(node)
      node.value[:text] ||= ''
      find_compiler(node).compile(node)
    end

    private

    def find_compiler(node)
      name = node.value[:name].to_sym
      compiler = Filters.registered[name]
      raise FilterNotFound.new("FilterCompiler for '#{name}' was not found", node.line.to_i - 1) unless compiler

      @compilers[name] ||= compiler.new(@options)
    end
  end
end
