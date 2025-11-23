import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  static values = { delay: { type: Number, default: 4000 } }

  connect() {
    // Inicia o temporizador assim que o elemento aparece no DOM
    this.timeout = setTimeout(() => {
      this.dismiss()
    }, this.delayValue)
  }

  dismiss() {
    // Adiciona uma classe de transição para suavizar a saída (opcional)
    this.element.classList.add("opacity-0", "translate-x-full")
    
    // Remove do DOM após a animação CSS (ex: 500ms)
    setTimeout(() => {
      this.element.remove()
    }, 500)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}