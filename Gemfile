# frozen_string_literal: true

source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :test do
  gem 'metadata-json-lint', require: false
  gem 'puppet-lint', require: false
  gem 'puppet-lint-absolute_template_path', require: false
  gem 'puppet-lint-classes_and_types_beginning_with_digits-check',
      require: false
  gem 'puppet-lint-concatenated_template_files-check', require: false
  gem 'puppet-lint-duplicate_class_parameters-check', require: false
  gem 'puppet-lint-leading_zero-check', require: false
  gem 'puppet-lint-legacy_facts-check', require: false
  gem 'puppet-lint-no_erb_template-check', require: false
  gem 'puppet-lint-no_file_path_attribute-check', require: false
  gem 'puppet-lint-no_symbolic_file_modes-check', require: false
  gem 'puppet-lint-param-docs', require: false
  gem 'puppet-lint-resource_reference_syntax', require: false
  gem 'puppet-lint-strict_indent-check', require: false
  gem 'puppet-lint-template_file_extension-check', require: false
  gem 'puppet-lint-trailing_newline-check', require: false
  gem 'puppet-lint-variable_contains_upcase', require: false
  gem 'puppet-lint-version_comparison-check', require: false
  gem 'puppet-lint-world_writable_files-check', require: false
  gem 'puppetlabs_spec_helper', require: false
  gem 'rspec-puppet', require: false
  gem 'rspec-puppet-facts', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'puppet-strings', require: false
end

gem 'facter', ENV['FACTER_GEM_VERSION']
gem 'hiera', ENV['HIERA_GEM_VERSION']
gem 'puppet', ENV['PUPPET_GEM_VERSION']
