# frozen_string_literal: true

require_relative "lib/reportsla/version"
require_relative "lib/reports/base"

Gem::Specification.new do |spec|
  spec.name          = "reportsla"
  spec.version       = Reportsla::VERSION
  spec.authors       = ["Enoch Tamulonis"]
  spec.email         = ["yungboiiindigo@gmail.com"]

  spec.summary       = "Reporting gem from coursla"
  spec.description   = "Gem to create reports"
  spec.homepage      = "https://scripla.com"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files        = Dir.glob("{bin,lib}/**/*") + %w()
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
