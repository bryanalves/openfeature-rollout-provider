# frozen_string_literal: true

require_relative "lib/openfeature/rollout/provider/version"

Gem::Specification.new do |spec|
  spec.name = "openfeature-rollout-provider"
  spec.version = OpenFeature::Rollout::VERSION
  spec.authors = ["Bryan Alves"]
  spec.email = ["bryanalves@gmail.com"]

  spec.summary = "The rollout provider for the OpenFeature Ruby SDK"
  spec.description = "The rollout provider for the OpenFeature Ruby SDK"
  spec.homepage = "https://github.com/bryanalves/openfeature-rollout-provider"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bryanalves/openfeature-rollout-provider/tree/main/"
  spec.metadata["bug_tracker_uri"] = "https://github.com/bryanalvees/openfeature-rollout-provider/issues"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "openfeature-sdk", "~> 0.3"
  spec.add_runtime_dependency "rollout"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_development_dependency "rubocop"
end
