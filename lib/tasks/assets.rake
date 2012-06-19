desc 'Build all required asset files'
task :assets do
  Bundler.with_clean_env do
    sh 'cd vendor/ember.js && bundle install --quiet && bundle exec rake'
  end
end

task 'test' => :assets
task 'konacha:run' => :assets
task 'assets:precompile' => :assets
