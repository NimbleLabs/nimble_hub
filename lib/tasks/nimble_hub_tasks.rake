# desc "Explaining what the task does"
task :twitter_task do
  NimbleHub::Tweets::LoadService.new.run
end
