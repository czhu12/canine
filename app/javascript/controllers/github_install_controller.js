import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener('click', this.handleClick.bind(this))
  }

  handleClick(event) {
    event.preventDefault()
    const url = this.element.href
    const popup = window.open(url, 'github-install', 'width=800,height=600')
    
    const checkPopup = setInterval(() => {
      if (popup.closed) {
        clearInterval(checkPopup)
        window.location.reload()
      }
    }, 1000)
  }
} 