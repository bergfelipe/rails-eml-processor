require 'rails_helper'

RSpec.describe "LogsProcessamentos", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/logs_processamentos/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/logs_processamentos/show"
      expect(response).to have_http_status(:success)
    end
  end

end
