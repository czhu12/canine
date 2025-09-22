import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["stackManagerForm", "portainerForm"]
  
  connect() {
    console.log("compiled")
  }

  submit() {
    const formData = new FormData(this.stackManagerFormTarget)
    fetch(this.stackManagerFormTarget.action, {
      method: 'POST',
      body: formData,
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      }
    })
    .then(() => {
      this.portainerFormTarget.classList.remove('hidden')
    })
    .catch(error => {
      console.error('Error:', error)
    })
  }

}
