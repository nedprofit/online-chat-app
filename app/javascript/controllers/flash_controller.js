import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="removals"
export default class extends Controller {

  connect() {
    this.removeAfterTimeout();
    this.limitNotifications();
  }

  removeAfterTimeout() {
    setTimeout(() => {
      setTimeout(() => {
        this.element.remove();
      }, 300); // 0.3 seconds
    }, 5000); // 5 seconds
  }

  limitNotifications() {
    const notifications = document.querySelectorAll("[data-controller='flash']");
    if (notifications.length > 3) {
      setTimeout(() => {
        notifications[0].remove();
      }, 300); // 0.3 seconds
    }
  }

  remove() {
    this.element.remove();
  }
}
