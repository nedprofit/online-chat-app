import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static values = {
        title: String,
        partial: String,
        url: String,
        turboFrame: String,
        hasContinue: Boolean,
        actionMethod: { type: String, default: "POST"}
    };

    openModal() {
        const customEvent = new CustomEvent("openModal", {
            bubbles: true,
            detail: {
                title: this.titleValue,
                url: this.urlValue,
                partial: this.partialValue,
                turbo_frame: this.turboFrameValue,
                has_continue: this.hasContinueValue,
                action_method: this.actionMethodValue
            },
        });

        this.element.dispatchEvent(customEvent);
    }
}
