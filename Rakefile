require 'bundler/gem_tasks'

#
# Prepend DevKit into compilation phase
#
if Gem.win_platform?
  desc 'Activates DevKit'
  task :devkit do
    begin
      require 'devkit'
    rescue LoadError
      abort 'Failed to load DevKit required for compilation'
    end
  end
  task compile: :devkit
end

require 'rake/testtask'
if /java/ === RUBY_PLATFORM
  # require 'rake/javaextensiontask'
  # Rake::JavaExtensionTask.new(:hamlit) do |ext|
  #   ext.ext_dir = 'ext/java'
  #   ext.lib_dir = 'lib/hamlit'
  # end

  task :compile do
    # dummy for now
  end
else
  require 'rake/extensiontask'
  Rake::ExtensionTask.new(:hamlit) do |ext|
    ext.lib_dir = 'lib/hamlit'
  end
end

Dir['benchmark/*.rake'].each { |b| import(b) }

namespace :haml do
  Rake::TestTask.new do |t|
    t.libs << 'lib' << 'test'
    files = Dir['test/haml/*_test.rb']
    files << 'test/haml/haml-spec/*_test.rb'
    t.ruby_opts = %w[-rtest_helper]
    t.test_files = files
    t.verbose = true
  end
end

namespace :hamlit do
  Rake::TestTask.new do |t|
    t.libs << 'lib' << 'test'
    t.ruby_opts = %w[-rtest_helper]
    t.test_files = Dir['test/hamlit/**/*_test.rb']
    t.verbose = true
  end
end

namespace :test do
  Rake::TestTask.new(:all) do |t|
    t.libs << 'lib' << 'test'
    files = Dir['test/hamlit/**/*_test.rb']
    files += Dir['test/haml/*_test.rb']
    files << 'test/haml/haml-spec/*_test.rb'
    t.ruby_opts = %w[-rtest_helper]
    t.test_files = files
    t.verbose = true
  end

  Rake::TestTask.new(:spec) do |t|
    t.libs << 'lib' << 'test'
    t.ruby_opts = %w[-rtest_helper]
    t.test_files = %w[test/haml/haml-spec/ugly_test.rb test/haml/haml-spec/pretty_test.rb]
    t.verbose = true
  end

  Rake::TestTask.new(:engine) do |t|
    t.libs << 'lib' << 'test'
    t.ruby_opts = %w[-rtest_helper]
    t.test_files = %w[test/haml/engine_test.rb]
    t.verbose = true
  end

  Rake::TestTask.new(:filters) do |t|
    t.libs << 'lib' << 'test'
    t.ruby_opts = %w[-rtest_helper]
    t.test_files = %w[test/haml/filters_test.rb]
    t.verbose = true
  end

  Rake::TestTask.new(:helper) do |t|
    t.libs << 'lib' << 'test'
    t.ruby_opts = %w[-rtest_helper]
    t.test_files = %w[test/haml/helper_test.rb]
    t.verbose = true
  end

  Rake::TestTask.new(:template) do |t|
    t.libs << 'lib' << 'test'
    t.ruby_opts = %w[-rtest_helper]
    t.test_files = %w[test/haml/template_test.rb]
    t.verbose = true
  end
end

desc 'bench task for CI'
task bench: :compile do
  cmd = %w[bundle exec ruby benchmark/run-benchmarks.rb]
  exit system(*cmd)
end

task default: %w[compile hamlit:test]
task test: %w[compile test:all]
