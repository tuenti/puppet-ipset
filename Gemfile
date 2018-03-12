# frozen_string_literal: true

source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :test do
  gem 'metadata-json-lint', require: false
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
