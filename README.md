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

### 1. Enviar arquivos `.eml` para processamento e insert

Em /arquivos_emails/new existe um formulário de upload:

- Envie um arquivo `.eml`
- O upload dispara um **job Sidekiq**
- O Sidekiq processa o arquivo em background
- O parser apropriado é selecionado com base no remetente do e-mail
- As infomasções do email são processadas e salvas no banco de dados.
- Em caso de erro o sisetma informará.

---

### 👥 2. Listar clientes criados

A página **Customers** (`/clientes`) exibe uma listagem com os dados básicos de cada cliente:

- Nome
- Email
- Telefone
- Produto de interesse
- Botão pro Show
---

#### 🔎 Detalhes do cliente – Show (`/clientes/:id`)

Ao clicar em um cliente, a página de **show** exibe:

- Nome completo
- Email
- Telefone
- Produto de interesse
- Data de criação
- Arquivo `.eml` relacionado

Além disso, o show do cliente contém:

- **Seção de log**: mostra o log completo referente ao e-mail que originou aquele cliente.
- **Botão "Ver Log Completo"** → que redireciona para `/logs_processamentos/:id`  
  (onde o usuário pode visualizar o processamento detalhado daquele e-mail).

---

### 📄 3. Visualizar logs de processamento

A página **Logs de Processamento** (`/logs_processamentos`) exibe uma listagem dos logs gerados pelos parsers:

- Arquivo processado
- Dados extraídos (nome, email, telefone, produto, etc.)
- Remetente (Parser A ou Parser B)
- Produto (quando identificado)
- Criado em (timestamp)
- Status: sucesso ou falha

---

#### 🔎 Detalhes do log – Show (`/logs_processamentos/:id`)

Ao clicar em um log específico, a página de **show** exibe:

- Arquivo `.eml` original (nome do arquivo ou link para download)
- Remetente identificado
- Dados extraídos:
  - Nome
  - Email
  - Telefone
  - Produto
  - Assunto
- Parser utilizado
- Mensagens de erro (se houver)
- Status final (sucesso/falha)
- Data e hora do processamento

No show do log existe também:

- **Seção do cliente gerado** (em caso de erro ele tenta indentificar duplicidade)
- **Botão "Ver Cliente"** → que redireciona para `/clientes/:id`

Isso permite navegar entre cliente ↔ log com facilidade.


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

