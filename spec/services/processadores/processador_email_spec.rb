require "rails_helper"

RSpec.describe Processadores::ProcessadorEmail do
  let(:blob_double) do
    double(
      service: ActiveStorage::Blob.service,
      key: "blob_key"
    )
  end

  # O attachment REAL do ActiveStorage expõe .key
  let(:attachment_double) do
    double(
      arquivo_email: double(
        key: "fornecedor_a",      # <-- ESSENCIAL
        blob: blob_double         # <-- JÁ EXISTIA
      )
    )
  end

  before do
    allow(ActiveStorage::Blob.service).to receive(:path_for)
      .and_return(Rails.root.join("spec/fixtures/emails/fornecedor_a.eml"))
  end

  it "seleciona corretamente o parser pelo remetente" do
    processor = described_class.new(attachment_double)
    parser = processor.send(
      :escolher_parser,
      Rails.root.join("spec/fixtures/emails/fornecedor_a.eml")
    )

    expect(parser).to be_a(Parsers::FornecedorAParser)
  end

  it "cria um cliente quando dados são válidos" do
    allow(Cliente).to receive(:find_by).and_return(nil)
    allow(Cliente).to receive(:create!).and_return(double(id: 123))

    processor = described_class.new(attachment_double)
    resultado = processor.executar

    expect(resultado[:cliente_id]).to eq(123)
  end

  it "retorna erro quando e-mail e telefone estão vazios" do
    allow_any_instance_of(Parsers::FornecedorAParser)
      .to receive(:extrair)
      .and_return({ nome: "Teste", email: nil, telefone: nil })

    processor = described_class.new(attachment_double)
    resp = processor.executar

    expect(resp[:erro]).to match(/Não foi possível/)
  end

  it "retorna erro se cliente já existe" do
    allow(Cliente).to receive(:find_by).and_return(double)

    processor = described_class.new(attachment_double)
    resp = processor.executar

    expect(resp[:erro]).to match(/Cliente já existe/)
  end
end
