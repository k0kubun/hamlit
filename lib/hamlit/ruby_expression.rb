# frozen_string_literal: true
require 'ripper'

module Hamlit
  class RubyExpression < Ripper
    class ParseError < StandardError; end

    def self.syntax_error?(code)
      self.new(code).parse
      false
    rescue ParseError
      true
    end

    def self.string_literal?(code)
      sexp = Ripper.sexp(code)
      return false unless sexp

      type, instructions = sexp
      return false if type != :program
      return false if instructions.size > 1

      type, _ = instructions.first
      type == :string_literal
    end

    private

    def on_parse_error(*)
      raise ParseError
    end
  end
end
