#!/usr/bin/env ruby

require 'bundler/setup'
require 'hamlit'
require 'benchmark/ips'
require_relative '../utils/benchmark_ips_extension'

Benchmark.ips do |x|
  x.report("Hamlit::AB.build_id") { Hamlit::AttributeBuilder.build_id(true, "book", %w[content active]) }
  x.compare!
end
