Dir.glob("#{File.dirname(__FILE__)}/hanami_sample/errors/*.rb").each { |e| require_relative e }

module HanamiSample
end
