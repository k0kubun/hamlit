# frozen_string_literal: true
require_relative "hamlit/engine.rb"
require_relative "hamlit/error.rb"
require_relative "hamlit/version.rb"
require_relative "hamlit/template.rb"

begin
  require 'rails'
  require_relative "railtie.rb"
rescue LoadError
end
