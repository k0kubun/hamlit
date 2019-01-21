# frozen_string_literal: true
require 'rails'

module Hamlit
  class Railtie < ::Rails::Railtie
    initializer :hamlit do |app|
      require_relative "rails_template.rb"
    end
  end
end
