// app/javascript/controllers/polling_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.reloadFrame()
  }

  // Função que inicia o temporizador e a recarga
  reloadFrame() {
    const interval = this.element.dataset.turboFrameReload || 5000;
    
    // Configura o timer
    this.timer = setInterval(() => {
      // Força o frame a fazer uma requisição GET para seu próprio src
      Turbo.visit(this.element.src, { frame: this.element.id });
    }, interval);
  }

  // Limpa o timer quando o elemento é desconectado (boa prática)
  disconnect() {
    clearInterval(this.timer);
  }
}