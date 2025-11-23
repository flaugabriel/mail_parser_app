module Parsers
  class BaseParser
    # Atributos comuns para os dados extraídos
    attr_reader :client_name, :client_email, :client_phone, :product_code, :subject

    def initialize(email_file_content)
      @email = Mail.read_from_string(email_file_content) # Dependência: gem 'mail'
      @subject = @email.subject
    end

    # Interface pública obrigatória para as subclasses (Template Method)
    def parse!
      # Lógica de extração de dados (a ser implementada pelos parsers específicos)
      raise NotImplementedError, "#{self.class} must implement method #extract_data"
    end

    # Regra de Negócio: Verifica se a extração falhou
    def processing_failed?
      @client_email.nil? && @client_phone.nil?
    end

    protected
    def extract_text_body
      body_content = @email.multipart? ? (@email.text_part || @email.html_part).decoded : @email.body.decoded

      body_content.force_encoding("UTF-8").encode("UTF-8", invalid: :replace, undef: :replace)
    end
  end
end
