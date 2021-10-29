# desc "Explaining what the task does"
task :twitter_task do
  NimbleHub::Twitter::LoadService.new.run
end
