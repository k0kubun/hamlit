# frozen_string_literal: true
require 'temple'
require 'hamlit/parser'
require 'hamlit/compiler'
require 'hamlit/html'
require 'hamlit/escapable'
require 'hamlit/force_escapable'
require 'hamlit/dynamic_merger'
require 'hamlit/ambles'

module Hamlit
  class Engine < Temple::Engine
    define_options(
      :buffer_class,
      generator:    Temple::Generators::StringBuffer,
      format:       :html,
      attr_quote:   "'",
      escape_html:  true,
      escape_attrs: true,
      autoclose:    %w(area base basefont br col command embed frame
                       hr img input isindex keygen link menuitem meta
                       param source track wbr),
      filename:     "",
      check_syntax: false,
      disable_capture: false,
    )

    use Parser
    use Compiler
    use HTML
    filter :StringSplitter
    filter :StaticAnalyzer
    use Escapable
    use ForceEscapable
    filter :ControlFlow
    use Ambles
    filter :MultiFlattener
    filter :StaticMerger
    use DynamicMerger
    use :Generator, -> { options[:generator] }
  end
end
