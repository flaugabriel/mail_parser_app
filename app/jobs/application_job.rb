class ApplicationJob < ActiveJob::Base
  def self.render(*args)
    ApplicationController.render(*args)
  end
end
