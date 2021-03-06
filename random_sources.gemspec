# encoding: utf-8

Gem::Specification.new do |gem|
  gem.name = 'random_sources'
  gem.version = "1.0"
  gem.date = Time.now.strftime('%Y-%m-%d')

  gem.summary = "Genuine random numbers and strings."
  gem.description = "The Random Sources library provides genuine random numbers, generated by processes fundamentally governed by inherent uncertainty instead of some pseudo-random number algorithm. It uses http services from different online providers."

  gem.authors = ['Juanjo Bazán']
  gem.email = "jjbazan@gmail.com"
  gem.homepage = 'http://github.com/xuanxu/random_sources'
  gem.license = 'MIT'

  gem.rdoc_options = ['--main', 'README.rdoc', '--charset=UTF-8']

  gem.files = %w(MIT-LICENSE.txt README.rdoc) + Dir.glob("{spec,lib/**/*}") & `git ls-files -z`.split("\0")
  gem.require_paths = ["lib"]
  gem.add_development_dependency("rspec", ">=3.8.0")
end
