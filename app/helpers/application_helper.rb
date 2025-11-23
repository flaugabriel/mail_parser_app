# app/helpers/application_helper.rb (ou um helper específico)
module ApplicationHelper
  # Adiciona classes de cor baseadas no status do log para fácil visualização
  def log_row_class(status)
    case status
    when "success"
      "table-success" # Verde
    when "failed"
      "table-warning" # Amarelo (Falha de Regra de Negócio: Faltou contato)
    when "error"
      "table-danger"  # Vermelho (Erro Técnico)
    else
      ""
    end
  end
end
