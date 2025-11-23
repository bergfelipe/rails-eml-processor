FROM ruby:3.0.6-bullseye

# Dependências do Rails + PostgreSQL + Node + Yarn
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs npm
RUN npm install --global yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

ENTRYPOINT ["./entrypoint.sh"]
