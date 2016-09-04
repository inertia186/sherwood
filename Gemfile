source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use Puma as the app server
gem 'puma', '~> 3.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'responders', '~> 2.2.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Templates
gem 'haml', '~> 4.0.7'

# Access the STEEM blockchain.
gem 'radiator', github: 'inertia186/radiator'

# Assets

gem 'bootstrap-glyphicons', '~> 0.0.1'
# Wraps the Angular.js UI Bootstrap library.
gem 'angular-ui-bootstrap-rails', '~> 1.3.2'

source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap', '~> 4.0.0.alpha.3'
  gem 'rails-assets-jquery', '~> 2.2.4'
  gem 'rails-assets-jquery-ujs', '~> 1.2.0'
  gem 'rails-assets-angular', '~> 1.5.7'
  gem 'rails-assets-angular-inview', '~> 1.5.7'
  gem 'rails-assets-angular-animate', '~> 1.5.7'
  gem 'rails-assets-angular-resource', '~> 1.5.7'
  gem 'rails-assets-angular-flash-alert', '~> 1.1.1'
  gem 'rails-assets-angular-cancel-on-navigate', '~> 0.1.0'
  gem 'rails-assets-ngclipboard', '~> 1.0.0'
  gem 'rails-assets-clipboard', '~> 1.5.10'
  gem 'rails-assets-nprogress', '~> 0.2.0'
  gem 'rails-assets-moment', '~> 2.13.0'
  gem 'rails-assets-chosen', '~> 1.5.1'
  # Tooltips and popovers depend on tether for positioning.
  gem 'rails-assets-tether', '>= 1.3.2'
  # Textarea editor.
  gem 'rails-assets-imperavi-redactor', '~> 10.0.9'
  gem 'rails-assets-angular-redactor', '~> 1.1.5'
end

group :development, :test do
  gem 'better_errors', require: false
  gem 'binding_of_caller', require: false
  gem 'rack-mini-profiler', '~> 0.10.1', require: false
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 9.0.5'
  gem 'pry-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.3.1'
end

group :test do
  gem 'capybara-angular', '~> 0.2.3'
  gem 'capybara-screenshot', '~> 1.0.13'
  # gem 'phantomjs', '~> 2.1.1.0', require: 'phantomjs/poltergeist'
  gem 'minitest', '~> 5.9.0'
  gem 'minitest-line'
  gem 'simplecov', '~> 0.11.2', require: false
  gem 'simplecov-csv', require: false
  gem 'webmock', '~> 2.1.0', require: false
  # See: https://github.com/myronmarston/vcr
  gem 'vcr', '~> 2.9.2'
  gem 'rails-controller-testing'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
