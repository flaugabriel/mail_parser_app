FROM ruby:3.3.0

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install -y nodejs npm

# Copia apenas Gemfile e Gemfile.lock primeiro (melhor p/ cache)
COPY Gemfile Gemfile.lock ./

# Instala as gems
RUN gem install bundler && bundle install --jobs 4 --retry 3

# Agora copia o resto da aplicação
COPY . .

# Precompila assets (opcional dependendo do Rails)
# RUN bundle exec rails assets:precompile

EXPOSE 3000
