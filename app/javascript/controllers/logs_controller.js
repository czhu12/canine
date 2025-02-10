import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]
  static values = {
    loggableId: String
  }

  scrollPositionId() {
    return `canine-scrollposition-${this.loggableIdValue}`;
  }

  connect() {
    const scrollPosition = localStorage.getItem(this.scrollPositionId());
    if (scrollPosition) {
      this.containerTarget.scrollTo(0, scrollPosition);
    } else {
      // Scroll to bottom
      this.scrollToBottom();
    }
  }

  disconnect() {
    localStorage.removeItem(this.scrollPositionId());
  }

  updateScroll(event) {
    // If scroll is at the bottom, don't save the scroll position
    if (event.target.scrollTop === event.target.scrollHeight) {
      localStorage.removeItem(this.scrollPositionId());
    } else {
      localStorage.setItem(this.scrollPositionId(), event.target.scrollTop);
    }
  }

  scrollToBottom() {
    this.containerTarget.scrollTop = this.containerTarget.scrollHeight;
  }
}
