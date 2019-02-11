require 'rake'
require 'hanami/rake_tasks'

Dir.glob("./lib/tasks/*.rb").each { |e| require_relative e }

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task test: :spec
  task default: :spec
rescue LoadError
end
