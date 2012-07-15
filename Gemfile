source :rubygems

# Dependencies specified in opal-rails.gemspec
gemspec

if File.exist? File.expand_path('~/Code/opal')
  gem 'opal',      :require => false, :path => '~/Code/opal'
  gem 'opal-dom',  :require => false, :path => '~/Code/opal-dom'
  gem 'opal-spec', :require => false, :path => '~/Code/opal-spec'
else
  gem 'opal',      :require => false, :git => 'git://github.com/elia/opal.git', :branch => 'another-18-fix'
  # gem 'opal',      :require => false, :git => 'git://github.com/adambeynon/opal.git'
  gem 'opal-dom',  :require => false, :git => 'git://github.com/adambeynon/opal-dom.git'
  gem 'opal-spec', :require => false, :git => 'git://github.com/adambeynon/opal-spec.git'
end


# Test app stuff

gem 'rails', '3.2.6'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'launchy'
end
