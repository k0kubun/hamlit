#!/usr/bin/env ruby
# frozen_string_literal: true

# Benchmark script for measuring individual C extension and compilation optimizations.
# Usage: bundle exec ruby benchmark/bench_internals.rb

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'hamlit'
require 'benchmark/ips'

# Heavy data hash — exercises hyphenate, merge_data_attrs_i, flatten_data_attrs,
# is_boolean_attribute, and hamlit_build_data with nested keys and underscores.
heavy_data = {
  "controller_name" => "users",
  "action_name"     => "index",
  "turbo_frame"     => "main_content",
  "loading_state"   => "lazy",
  "nested" => {
    "deep_key"    => "val1",
    "another_key" => "val2",
    "third_item"  => "val3",
  },
}

heavy_attrs = {
  "class" => "btn btn-primary",
  "id"    => "submit-form",
  "data"  => heavy_data,
  "aria"  => { "label" => "Submit", "described_by" => "help-text" },
  "disabled" => true,
  "data-turbo-method" => "post",
}

# Template with scripts and attribute values, so compilation goes through
# RubyExpression.string_literal? and the attribute compilers.
haml_code = <<~'HAML'
  %html
    %head
      %title= "Test"
    %body
      %h1{ class: "title", data: { user_id: "1" } } Hello
      %p= user.name
      %a{ href: "/users", title: "Users" }= "List"
      %span{ id: "item-#{id}", class: ["a", klass] }= "#{count} items"
HAML

puts "=== Speed (iterations/second) ==="
puts "warmup: 5s, measurement: 10s"
puts

Benchmark.ips do |x|
  x.config(warmup: 5, time: 10)

  x.report("build_data (heavy)") do
    Hamlit::AttributeBuilder.build_data(true, '"', heavy_data)
  end

  x.report("build (heavy)") do
    Hamlit::AttributeBuilder.build(true, '"', :html, ["disabled", "checked", "data-turbo-permanent"], nil, heavy_attrs)
  end

  x.report("Compilation") do
    Hamlit::Engine.new.call(haml_code)
  end
end

puts
puts "=== Memory (object allocations per call) ==="
puts

def measure_allocs(label, n = 1000)
  # Warmup
  50.times { yield }

  GC.start
  GC.disable
  before = ObjectSpace.count_objects
  n.times { yield }
  after = ObjectSpace.count_objects
  GC.enable

  strings = (after[:T_STRING] - before[:T_STRING]).to_f / n
  arrays  = (after[:T_ARRAY] - before[:T_ARRAY]).to_f / n
  hashes  = (after[:T_HASH] - before[:T_HASH]).to_f / n

  printf "%-30s strings: %6.1f  arrays: %5.1f  hashes: %5.1f\n",
    label, strings, arrays, hashes
end

measure_allocs("build_data (heavy)") do
  Hamlit::AttributeBuilder.build_data(true, '"', heavy_data)
end

measure_allocs("build (heavy)") do
  Hamlit::AttributeBuilder.build(true, '"', :html, ["disabled", "checked", "data-turbo-permanent"], nil, heavy_attrs)
end

measure_allocs("Compilation") do
  Hamlit::Engine.new.call(haml_code)
end
