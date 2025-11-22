require 'rails_helper'

RSpec.describe "ArquivosTestes", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/arquivos_teste/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/arquivos_teste/create"
      expect(response).to have_http_status(:success)
    end
  end

end
