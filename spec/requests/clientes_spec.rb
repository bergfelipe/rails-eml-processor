require 'rails_helper'

RSpec.describe "Clientes", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/clientes/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/clientes/show"
      expect(response).to have_http_status(:success)
    end
  end

end
