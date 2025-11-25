# Processador EML – Desafio Técnico C2S (Pleno)

Aplicação Ruby on Rails para processar arquivos **.eml**, extrair informações estruturadas e armazenar dados de clientes e logs de processamento.  
O sistema utiliza **arquitetura extensível de parsers**, processamento em background com **Sidekiq + Redis**, interface web simples e ambiente totalmente containerizado com **Docker + Docker Compose**.

---

## Tecnologias Utilizadas

[![Docker](https://img.shields.io/badge/Docker-0db7ed?style=flat&logo=docker&logoColor=white)](https://www.docker.com/)
[![Ruby on Rails](https://img.shields.io/badge/Rails-c92228?style=flat&logo=rubyonrails&logoColor=white)](https://rubyonrails.org/)
[![Ruby](https://img.shields.io/badge/Ruby-CC342D?style=flat&logo=ruby&logoColor=white)](https://www.ruby-lang.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-31648C?style=flat&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Redis](https://img.shields.io/badge/Redis-dc382d?style=flat&logo=redis&logoColor=white)](https://redis.io/)
[![Sidekiq](https://img.shields.io/badge/Sidekiq-A33626?style=flat&logo=ruby&logoColor=white)](https://sidekiq.org/)
[![Bootstrap](https://img.shields.io/badge/Bootstrap-7952b3?style=flat&logo=bootstrap&logoColor=white)](https://getbootstrap.com/)

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

### 2. Listar clientes criados

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

### 3. Visualizar logs de processamento

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

## Limpeza periódica dos logs (`LOG_RETENTION_DAYS`)

O projeto utiliza a variável de ambiente **`LOG_RETENTION_DAYS`** para definir por quantos dias os registros de processamento serão mantidos no banco de dados.
Essa variável já está configurada no `docker-compose.yml` como 30 dias:
LOG_RETENTION_DAYS: 30



## Arquitetura da Aplicação

### Estrutura principal

A aplicação contém 4 classes principais:

---

###  1. `EmailProcessor` services/processadores/processador_email.rb:

Responsável por decidir qual parser utilizar com base no remetente do e-mail.

---

###  2. `BaseParser` services/parsers/base_parser.rb:

Define a interface comum para todos os parsers:

- `parse`
- `extract_client_name`
- `extract_email`
- `extract_phone`
- `extract_product_code`

---

###  3. Parsers específicos A e B

São elas:

- `FornecedorAParser` services/parsers/fornecedor_a_parser.rb
- `ParceiroBParser` services/parsers/parceiro_b_parser.rb


## Testes Automatizados (RSpec)

Este projeto inclui uma suíte completa de testes automatizados utilizando **RSpec**, abrangendo:

- Parsers (`FornecedorAParser` e `ParceiroBParser`)
- Classe base `BaseParser`
- Classe de processamento `ProcessadorEmail`
- Rotas e controllers essenciais
- Integração com Active Storage (mockado nos testes)

Todos os testes foram configurados para rodar corretamente dentro do ambiente Docker.

### Como rodar os testes

Para executar toda a suíte de testes, utilize: docker compose exec app bundle exec rspec
Os testes utilizam fixtures reais `.eml` localizados em: spec/fixtures/emails/
Durante a execução, o Active Storage é totalmente **mockado** para evitar dependências externas, garantindo que os testes sejam determinísticos.

---

## Integração Contínua (CI) – Diferencial

Este projeto foi preparado para funcionar com **GitHub Actions**, permitindo que a suíte de testes seja executada automaticamente a cada **push** ou **pull request**.

Com o pipeline de CI ativado, o GitHub configurará automaticamente um ambiente contendo Ruby, PostgreSQL e Redis, carregará o schema do banco de testes e executará todos os testes RSpec.  
Isso garante que cada alteração no repositório seja validada antes de ser integrada, aumentando a confiabilidade e a qualidade do código.

Para ativar a CI, basta adicionar um workflow dentro da pasta: .github/workflows/



# Instalação e Execução (via Docker)

Siga os passos abaixo para subir o ambiente completo já com o Sidekiq, Redis, PostgreSQL e o ambiente de testes funcionando.

---

```bash
# 1. Clonar o repositório
git clone https://github.com/bergfelipe/rails-eml-processor.git
cd rails-eml-processor

# 2. Construir as imagens
docker compose build

# 3. Subir os containers (modo background)
docker compose up -d

# 4. Criar e carregar o banco de dados (desenvolvimento)
docker compose exec app rails db:create db:migrate

# 5. Preparar o banco de testes
docker compose exec app rails db:create db:schema:load RAILS_ENV=test

# 6. Executar a suíte de testes RSpec
docker compose exec app bundle exec rspec


