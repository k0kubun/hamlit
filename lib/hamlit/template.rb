# frozen_string_literal: false
require 'temple'
require 'hamlit/engine'
require 'hamlit/helpers'

module Hamlit
  Template = Temple::Templates::Tilt.create(
    Hamlit::Engine,
    register_as: [:haml, :hamlit],
  )

  module TemplateExtension
    # Activate Hamlit::Helpers for tilt templates.
    # https://github.com/judofyr/temple/blob/v0.7.6/lib/temple/mixins/template.rb#L7-L11
    def compile(*)
      "extend Hamlit::Helpers; #{super}"
    end
  end
  Template.send(:extend, TemplateExtension)
end
