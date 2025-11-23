require "rails_helper"

RSpec.describe EmailFilesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/email_files").to route_to("email_files#index")
    end

    it "routes to #new" do
      expect(get: "/email_files/new").to route_to("email_files#new")
    end

    it "routes to #show" do
      expect(get: "/email_files/1").to route_to("email_files#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/email_files/1/edit").to route_to("email_files#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/email_files").to route_to("email_files#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/email_files/1").to route_to("email_files#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/email_files/1").to route_to("email_files#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/email_files/1").to route_to("email_files#destroy", id: "1")
    end
  end
end
