# config/routes.rb
Rails.application.routes.draw do
  # Rota principal para o formulário e listagens
  resources :email_files, only: [ :index, :create ]

  # Define a página inicial
  root "email_files#index"

  # Rota para o Sidekiq Web UI (Opcional, mas altamente recomendado para monitoramento)
  # Requer autenticação em ambiente de produção!
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"
end
