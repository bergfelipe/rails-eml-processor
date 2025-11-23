# Processador EML – Desafio Técnico C2S (Pleno)

Aplicação Ruby on Rails para processar arquivos **.eml**, extrair informações estruturadas e armazenar dados de clientes e logs de processamento.  
O sistema utiliza **arquitetura extensível de parsers**, processamento em background com **Sidekiq + Redis**, interface web simples e ambiente totalmente containerizado com **Docker + Docker Compose**.

---

## Tecnologias Utilizadas

- **Ruby 3.0.6**
- **Rails 7.1.6**
- **PostgreSQL 14**
- **Redis 7**
- **Sidekiq**
- **Docker / Docker Compose**
- **Bootstrap 5**

---

## Uso do sistema

### 1. Enviar arquivos `.eml` para processamento

Em /arquivos_emails/new existe um formulário de upload:

- Envie um arquivo `.eml`
- O upload dispara um **job Sidekiq**
- O Sidekiq processa o arquivo em background
- O parser apropriado é selecionado com base no remetente do e-mail

---

### 2. Listar clientes criados

A página **Customers** /clientes exibe:

- Nome
- Email
- Telefone
- Produto de interesse

---

### 3. Visualizar logs de processamento

A página de **logs** /logs_processamentos exibe:

- Arquivo processado
- Dados extraídos
- Rementente(parse A ou B)
- Produto (se existirem)
- Criado em
- Status: sucesso ou falha

---

## ⚙️ Arquitetura da Aplicação

### Estrutura principal

A aplicação contém as seguintes classes principais:

---

### ✔️ 1. `EmailProcessor` services/processadores/processador_email.rb:

Responsável por decidir qual parser utilizar com base no remetente do e-mail.

---

### ✔️ 2. `BaseParser` services/parsers/base_parser.rb:

Define a interface comum para todos os parsers:

- `parse`
- `extract_client_name`
- `extract_email`
- `extract_phone`
- `extract_product_code`

---

### ✔️ 3. Parsers específicos

São elas:

- `FornecedorAParser` services/parsers/fornecedor_a_parser.rb
- `ParceiroBParser` services/parsers/parceiro_b_parser.rb


# Instalação e Execução (via Docker)

Siga os passos abaixo para subir o ambiente completo.
---

```bash
## Clonar o repositório
git clone https://github.com/seu-usuario/rails-eml-processor.git
cd rails-eml-processor
## Construir as imagens
docker compose build
##  Subir os containers
docker compose up

