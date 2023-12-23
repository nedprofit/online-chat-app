import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["notification", "chatName", "messageBody"];

    connect() {
        document.addEventListener("showNotification", this.showNotification.bind(this));
    }

    disconnect() {
        document.removeEventListener("showNotification", this.showNotification.bind(this));
        clearTimeout(this.contentTimeout);
    }

    showNotification(event) {
        this.chatNameTarget.textContent = event.detail.chat_name;
        this.messageBodyTarget.textContent = event.detail.message_body;
        this.notificationTarget.classList.remove("hidden");

        this.contentTimeout = setTimeout(() => {
            this.notificationTarget.classList.add("hidden");
        }, 3000); // скрывать через 5 секунд
    }

    closeNotification() {
        this.notificationTarget.classList.add("hidden");
        clearTimeout(this.contentTimeout);
    }
}