Sidekiq.configure_server do |config|
  # Usa a variável de ambiente REDIS_URL para conectar, garantindo que o host 'redis' seja usado.
  config.redis = { url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } }
end
