class EmailProcessorService
  SENDER_MAPPING = {
    "fornecedora.com" => Parsers::SupplierAParser,
    "parceiro.com" => Parsers::PartnerBParser
    # Facilidade de adicionar novos parsers aqui, sem mexer no BaseProcessor!
  }.freeze

  def initialize(email_file_content)
    @email_content = email_file_content
    @email = Mail.read_from_string(@email_content)
  end

  def process
    full_sender_email = @email.from.first.downcase
    domain = full_sender_email.split("@").last
    parser_class = SENDER_MAPPING.find { |key, klass| domain.include?(key) }&.last

    if parser_class
      parser = parser_class.new(@email_content)
      parser.parse!

      parser
    else
      raise "Parser não encontrado para o domínio: #{domain} (Remetente: #{full_sender_email})"
    end

  rescue StandardError => e
    # Garante que erros de parsing também sejam capturados e logados
    raise "Falha no processamento do email: #{e.message}"
  end
end
