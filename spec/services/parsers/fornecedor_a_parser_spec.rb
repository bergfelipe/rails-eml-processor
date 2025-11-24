require "rails_helper"

RSpec.describe Parsers::FornecedorAParser do
  let(:arquivo) { Rails.root.join("spec/fixtures/emails/fornecedor_a.eml") }
  let(:parser)  { described_class.new(arquivo) }

  let(:dados) { parser.extrair }

  it "extrai corretamente o nome" do
    expect(dados[:nome]).to eq("João da Silva")
  end

  it "extrai corretamente o e-mail" do
    expect(dados[:email]).to eq("joao.silva@example.com")
  end

  it "extrai corretamente o telefone" do
    expect(dados[:telefone]).to eq("(11) 91234-5678")
  end

  it "extrai corretamente o código do produto" do
    expect(dados[:codigo_produto]).to eq("ABC123")
  end
end
