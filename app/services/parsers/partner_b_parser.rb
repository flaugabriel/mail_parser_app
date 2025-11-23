class Parsers::PartnerBParser < Parsers::BaseParser
    # As expressões regulares aqui são mais flexíveis, buscando padrões no texto.

    # Assumimos que o nome do cliente pode vir na primeira linha após a saudação
    # ou próximo ao encerramento (não é um campo rotulado como no Fornecedor A).
    # Para este exemplo, vamos buscar o nome no final, se não for encontrado no corpo.
    CLIENT_NAME_REGEX_END = /Atenciosamente,\s*(\S+.*)/i

    # RegEx padrão para e-mails: qualquer sequência de não-espaço com @ e um ponto.
    CLIENT_EMAIL_REGEX = /[\w\.-]+@[\w\.-]+\.\w+/i

    # RegEx padrão para telefone: busca por sequências de dígitos com separadores comuns.
    CLIENT_PHONE_REGEX = /[\d\s\(\)\-]{8,20}/i

    # Código do produto: assumimos que o Parceiro B usa códigos no formato 'PB-XYZ-001'
    PRODUCT_CODE_REGEX = /(PB-[A-Z0-9\-]+)/i

    # Implementação da Estratégia
    def parse!
      body = extract_text_body

      # 1. Extração do E-mail e Telefone (campos obrigatórios para sucesso/falha)
      # Usamos o primeiro match encontrado no corpo
      @client_email = extract_first_match(body, CLIENT_EMAIL_REGEX)
      @client_phone = extract_first_match(body, CLIENT_PHONE_REGEX)

      # 2. Extração do Código do Produto
      @product_code = extract_first_match(body, PRODUCT_CODE_REGEX)

      # 3. Tentativa de Extração do Nome
      # Se o parceiro B não rotula o nome, tentamos extrair do encerramento
      @client_name = extract_field(body, CLIENT_NAME_REGEX_END)

      # O BaseParser já cuidará da regra de negócio de falha se faltarem e-mail E telefone.
    end

    private

    # Método auxiliar para aplicar o RegEx de forma limpa e segura (usado no Fornecedor A)
    def extract_field(text, regex)
      match = text.match(regex)
      match ? match[1].strip : nil
    end

    # Novo método auxiliar para encontrar a primeira ocorrência do padrão no corpo,
    # útil para extrair e-mails e telefones quando não há rótulos claros.
    def extract_first_match(text, regex)
      match = text.match(regex)
      match ? match[0].strip : nil # Retorna o match completo (grupo 0)
    end

    def to_h_of_extracted_data
      {
        client_name: @client_name,
        client_email: @client_email,
        client_phone: @client_phone,
        product_code: @product_code,
        subject: @subject
      }
    end
end
