class Parsers::SupplierAParser < Parsers::BaseParser
  # As expressões regulares buscam o padrão seguido por dois pontos (:) e capturam o texto seguinte.
  # Elas usam \s* para permitir zero ou mais espaços entre o rótulo e o valor, aumentando a robustez.

  CLIENT_NAME_REGEX = /Nome do cliente:\s*(.*)/i
  CLIENT_EMAIL_REGEX = /E-mail:\s*(\S+@\S+)/i
  CLIENT_PHONE_REGEX = /Telefone:\s*([\(\)\s\d-]+)/i # Captura dígitos, parênteses, espaços e hífens
  PRODUCT_CODE_REGEX = /produto de código\s*([\w\-\_]+)/i # Captura qualquer sequência de não-espaço após o rótulo

  # Implementação da Estratégia
  def parse!
    # Extrai o corpo de texto limpo do e-mail
    body = extract_text_body

    # Extrai cada campo usando a Expressão Regular e armazena nos atributos de instância (@)
    @client_name = extract_field(body, CLIENT_NAME_REGEX)
    @client_email = extract_field(body, CLIENT_EMAIL_REGEX)
    @client_phone = extract_field(body, CLIENT_PHONE_REGEX)

    # O código do produto neste exemplo está no corpo de forma diferente
    @product_code = extract_field(body, PRODUCT_CODE_REGEX)

    # O Assunto já foi capturado no BaseParser, mas é incluído aqui para clareza
    # @subject está disponível via BaseParser

    # Validação da Regra de Negócio: O BaseParser já possui o método `processing_failed?`
    # que verificará se @client_email E @client_phone são nulos após esta extração.
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
