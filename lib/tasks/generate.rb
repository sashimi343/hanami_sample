GENERATOR_TEMPLATE = "lib/tasks/generator_template"
INTERACTORS = "lib/hanami_sample/interactors"
VALIDATORS = "lib/hanami_sample/validators"
INTERACTOR_SPECS = "spec/hanami_sample/interactors"
VALIDATOR_SPECS = "spec/hanami_sample/validators"

desc "Generate interactor/validator"
task :generate do
  ARGV.each { |e| task e.to_sym do ; end }
  
  sub_command = ARGV[1] || "help"
  param = ARGV[2] || ""

  case sub_command
  when "interactor"
    generate_interactor(param)
  when "validator"
    generate_validator(param)
  when "help"
    show_usage
  else
    puts "Unknown command: #{sub_command}"
    show_usage
  end
end

task g: :generate

def show_usage
  puts "commands:"
  puts '  rake generate interactor MODULE#ACTION  # Generate interactor'
  puts '  rake generate validator NAME            # Generate validator'
  puts '  rake generate help                      # Show this message'
end

def generate_interactor(param)
  if /\A([a-z][a-z0-9_]+)#([a-z][a-z0-9_]+)\z/i =~ param
    module_name = to_camel("#{$1}Interactor")
    class_name = to_camel("#{$2}")
    interactor_path = "#{INTERACTORS}/#{to_snake(module_name)}/#{to_snake(class_name)}.rb"
    interactor_spec_path = "#{INTERACTOR_SPECS}/#{to_snake(module_name)}/#{to_snake(class_name)}_spec.rb"

    mkdir_p(File.dirname(interactor_path))
    mkdir_p(File.dirname(interactor_spec_path))
    puts "create #{interactor_path}"
    create_from_template("interactor", interactor_path, module_name, class_name)
    puts "create #{interactor_spec_path}"
    create_from_template("interactor_spec", interactor_spec_path, module_name, class_name)
  else
    puts "commands:"
    puts '  rake generate interactor MODULE#ACTION  # Generate interactor'
  end
end

def generate_validator(param)
  if /\A([a-z][a-z0-9_]+)\z/i =~ param
    class_name = to_camel("#{$1}Validator")
    validator_path = "#{VALIDATORS}/#{to_snake(class_name)}.rb"
    validator_spec_path = "#{VALIDATOR_SPECS}/#{to_snake(class_name)}_spec.rb"

    mkdir_p(File.dirname(validator_path))
    mkdir_p(File.dirname(validator_spec_path))
    puts "create #{validator_path}"
    create_from_template("validator", validator_path, '', class_name)
    puts "create #{validator_spec_path}"
    create_from_template("validator_spec", validator_spec_path, '', class_name)
  else
    puts "commands:"
    puts '  rake generate validator NAME            # Generate validator'
  end
end

def create_from_template(template_name, dst_path, module_name, class_name)
  template = File.read("#{GENERATOR_TEMPLATE}/#{template_name}.rb.template")
  body = template.gsub("MODULE_NAME", module_name).gsub("CLASS_NAME", class_name)
  File.write(dst_path, body)
end

def to_camel(str)
  str.split(/_/).map{ |w| w[0] = w[0].upcase; w }.join
end

def to_snake(str)
	str.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
		.gsub(/([a-z\d])([A-Z])/, '\1_\2')
		.downcase
end
