module Hamlit
  class Generator < Temple::Generators::ArrayBuffer
    def call(exp)
      if save_buffer.nil? && restore_buffer.nil? &&
         exp.first == :dynamic && RubyExpression.string_literal?(exp.last)
        exp.last
      else
        super
      end
    end
  end
end
