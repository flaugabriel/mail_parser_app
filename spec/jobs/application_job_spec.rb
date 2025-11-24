require "rails_helper"

RSpec.describe ApplicationJob, type: :job do
  describe ".render" do
    it "delegates to ApplicationController.render with the given arguments" do
      args = { partial: "layouts/flash", locals: { message: "Hello" } }

      # Espiona ApplicationController.render
      expect(ApplicationController).to receive(:render).with(*args)

      # Chama o método de classe
      ApplicationJob.render(*args)
    end
  end
end
