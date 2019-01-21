# frozen_string_literal: true
require_relative "../parser/haml_util.rb"

module Hamlit
  class Filters
    class Base
      def initialize(options = {})
        @format = options[:format]
      end
    end
  end
end
