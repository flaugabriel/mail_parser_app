require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  describe "#render_turbo_flash" do
    it "chama turbo_stream.update com partial correto" do
      # Criamos um double para receber `update`
      turbo_stream_double = double("TurboStream")

      # Stub no método privado turbo_stream para retornar nosso double
      allow(controller).to receive(:turbo_stream).and_return(turbo_stream_double)

      # Esperamos que update seja chamado com os argumentos corretos
      expect(turbo_stream_double).to receive(:update).with(
        "flash-messages",
        partial: "layouts/flash"
      )

      # Chamamos o método diretamente
      controller.render_turbo_flash
    end
  end
end
