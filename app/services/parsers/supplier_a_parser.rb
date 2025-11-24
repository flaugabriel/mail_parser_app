class Parsers::SupplierAParser < Parsers::BaseParser
  CLIENT_NAME_REGEX = /Nome do cliente:\s*(.*)/i
  CLIENT_EMAIL_REGEX = /E-mail:\s*(\S+@\S+)/i
  CLIENT_PHONE_REGEX = /Telefone:\s*([\(\)\s\d-]+)/i
  PRODUCT_CODE_REGEX = /produto de código\s*([\w\-\_]+)/i

  def parse!
    body = extract_text_body

    @client_name = extract_field(body, CLIENT_NAME_REGEX)
    @client_email = extract_field(body, CLIENT_EMAIL_REGEX)
    @client_phone = extract_field(body, CLIENT_PHONE_REGEX)

    @product_code = extract_field(body, PRODUCT_CODE_REGEX)
  end

  # Adicionar um método para tornar os dados extraídos acessíveis para o Log
  def to_h_of_extracted_data
     {
       client_name: @client_name,
       client_email: @client_email,
       client_phone: @client_phone,
       product_code: @product_code,
       subject: @subject
     }
  end

  private

  # Método auxiliar para aplicar o RegEx de forma limpa e segura
  def extract_field(text, regex)
    match = text.match(regex)
    # Garante que, se houver match, apenas o primeiro grupo de captura seja retornado e limpo
    match ? match[1].strip : nil
  end
end
