source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.2"

gem "dry-transaction"
gem "dry-validation"
gem "parallel"
gem "puma", "~> 5.0"
gem "rails", "~> 6.1.3"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "pry-rails"
  gem "rspec-rails"
  gem "standard", "~> 0.1"
end

group :development do
  gem "spring"
  gem "spring-commands-rspec"
  gem "spring-commands-standard"
  gem "spring-watcher-listen"
  gem "listen", "~> 3.3"
end

group :test do
  gem "webmock"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
