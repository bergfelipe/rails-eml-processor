require "rails_helper"

RSpec.describe Parsers::BaseParser do
  let(:arquivo) { Rails.root.join("spec/fixtures/emails/fornecedor_a.eml") }
  let(:parser) { described_class.new(arquivo) }

  it "carrega o e-mail corretamente" do
    expect(parser.mail).to be_a(Mail::Message)
  end

  it "normaliza texto mesmo com encoding inválido" do
    allow_any_instance_of(String).to receive(:valid_encoding?).and_return(false)
    expect(parser.normalize("abc")).to be_a(String)
  end

  it "exige implementação do método extrair" do
    expect { parser.extrair }.to raise_error(NotImplementedError)
  end
end
