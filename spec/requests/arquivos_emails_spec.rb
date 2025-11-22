require 'rails_helper'

RSpec.describe "ArquivosEmails", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/arquivos_emails/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/arquivos_emails/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/arquivos_emails/create"
      expect(response).to have_http_status(:success)
    end
  end

end
