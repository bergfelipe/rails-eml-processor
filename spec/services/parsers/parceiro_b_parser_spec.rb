require "rails_helper"

RSpec.describe Parsers::ParceiroBParser do
  let(:arquivo) { Rails.root.join("spec/fixtures/emails/parceiro_b.eml") }
  let(:parser)  { described_class.new(arquivo) }

  let(:dados) { parser.extrair }

  it "extrai corretamente o nome" do
    expect(dados[:nome]).to eq("Ricardo Almeida")
  end

  it "extrai corretamente o e-mail" do
    expect(dados[:email]).to eq("ricardo.almeida@example.com")
  end

  it "extrai corretamente o telefone" do
    expect(dados[:telefone]).to eq("41 98888-2222")
  end

  it "extrai corretamente o código do produto" do
    expect(dados[:codigo_produto]).to eq("PROD-888")
  end
end
