import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["form", "input"]

    submitOnEnter(event) {
        if (event.keyCode === 13 && !event.shiftKey) {
            event.preventDefault();
            this.formTarget.requestSubmit();
        }
    }

    clearInput() {
        this.inputTarget.value = "";
    }
}
