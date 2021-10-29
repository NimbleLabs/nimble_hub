module NimbleHub
  class LoadTwitterJob < NimbleHub::ApplicationJob
    def perform
      NimbleHub::Tweets::LoadService.new.run
    end
  end
end