class Customer < ApplicationRecord
  # Validações básicas (Domain constraints)
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
end
