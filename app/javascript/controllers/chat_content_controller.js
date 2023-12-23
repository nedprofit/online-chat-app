import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
    openChatContent() {
        const url = this.element.getAttribute('data-url');

        let elems = document.querySelectorAll(".draft__nav--open");

        [].forEach.call(elems, function (el) {
            el.classList.remove("draft__nav--open");
        });

        this.element.classList.add("draft__nav--open");

        fetch(url, {
            method: "GET",
            headers: {
                Accept: "text/vnd.turbo-stream.html",
            },
        })
            .then((r) => r.text())
            .then((html) => Turbo.renderStreamMessage(html));
    }
}
