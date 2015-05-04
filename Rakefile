require 'FileUtils'

desc 'Setup the testing env'
task :tom_setup do
  FileUtils.mkdir(File.join(Dir.home, 'tmp'))
  FileUtils.chdir(File.join(Dir.home, 'tmp'))
  `git clone --depth 1 git@github.com:sensu-plugins/tom_servo.git`
  FileUtils.chdir('tom_servo')
  rake setup:setup_env
end

desc 'Run the testing env'
task :tom_test do
  FileUtils.chdir(File.join(Dir.home, 'tmp', 'tom_servo'))
  rake testing:execute_all_tests
end

desc 'Deployment'
task :tom_deploy do
  FileUtils.chdir(File.join(Dir.home, 'tmp', 'tom_servo'))
  rake deploy:deploy
end
