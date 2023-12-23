import {Controller} from "@hotwired/stimulus";

const ACTION_METHODS = ["POST", "PATCH", "PUT"];

export default class extends Controller {
    static targets = [
        "modal",
        "title",
        "content",
        "footer",
        "loader",
        "continueButton"
    ];

    static properties = {
        title: String,
        url: String,
        partial: String,
        container: String,
        container_id: String,
        turbo_frame: String,
        has_continue: Boolean,
        action_method: String
    };

    connect() {
        document.addEventListener("openModal", this.openModal.bind(this));
    }

    disconnect() {
        document.removeEventListener("openModal", this.openModal.bind(this));
        clearTimeout(this.contentTimeout);
    }

    async openModal(event) {
        this.modalTarget.dataset.turboModalOpened = "true";

        this.title = event.detail.title;
        this.url = event.detail.url;
        this.partial = event.detail.partial;
        this.container = event.detail.container;
        this.container_id = event.detail.container_id;
        this.turbo_frame = event.detail.turbo_frame;
        this.has_continue = event.detail.has_continue;

        const tmpActionMethod = event.detail.action_method.toString().toUpperCase();
        this.action_method = ACTION_METHODS.includes(tmpActionMethod) ? tmpActionMethod : "POST";

        this.toggleModal()

        this.titleTarget.innerHTML = this.title;

        // Fetch the data remotely
        const response = await fetch(this.url, {
            method: "GET",
            headers: {
                "Turbo-Frame": "modal",
                Accept: "text/html",
                "Partial": this.partial,
                "Container": this.container,
                "Container-Id": this.container_id
            },
        });

        await response.text().then((html) => {
            if (response.ok) {
                // Update the modal content with the fetched data
                this.contentTarget.innerHTML = html;

                if (this.has_continue && this.hasContinueButtonTarget) {
                    this.continueButtonTarget.classList.remove("hidden");
                }

                this.showFooter();
            } else {
                if (response.status === 403) {
                    this.contentTarget.innerHTML = this.renderThisPageIsForbidden();
                }

                this.hideFooter();
            }

            this.toggleLoader();
        });
    }

    renderThisPageIsForbidden() {
        const lang = document.documentElement.lang;

        return `
            <div class="alert alert-error text-white !justify-start">
                <svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                <span>
                    ${lang === "ru" ? "У Вас нет прав для посещения данной страницы." : "You are not authorised to access this page."}
                </span>
            </div>
        `;
    }

    toggleModal() {
        this.modalTarget.classList.toggle('hidden');
    }

    toggleLoader() {
        this.loaderTarget.classList.toggle('hidden');
    }

    showFooter() {
        this.footerTarget.classList.remove('hidden');
    }

    hideFooter() {
        this.footerTarget.classList.add('hidden');
    }

    async submit({ params: { isContinueButton } }) {
        const form = this.contentTarget.querySelector('form');
        const formData = new FormData(form);

        this.toggleLoader()
        this.hideFooter();

        this.contentTarget.classList.add("opacity-20")

        const headers = {
            Accept: "text/vnd.turbo-stream.html",
            "Turbo-Frame": this.turbo_frame,
            "Submit-Source": isContinueButton ? "continue" : "submit"
        };

        const csrfTokenMeta = document.querySelector("meta[name='csrf-token']");
        if (csrfTokenMeta) {
            headers["X-CSRF-Token"] = csrfTokenMeta.content;
        }

        //заменено на async/await, чтобы была возможность отрендерить модальное окно даже при наличии ошибки
        const response = await fetch(form.action, {
            method: this.action_method,
            body: formData,
            headers,
        });

        await response.text()
            .then((html) => {
                Turbo.renderStreamMessage(html);
            })
            .then(() => {
                this.contentTarget.classList.remove("opacity-20")
                this.toggleLoader();
                this.showFooter();

                if (response.ok && !isContinueButton) {
                    this.closeModal();
                }
            });
    }

    closeModal() {
        this.modalTarget.dataset.turboModalOpened = "false";
        this.modalTarget.classList.add('hidden');
        this.continueButtonTarget.classList.add("hidden");
        this.toggleLoader();
        this.hideFooter();

        this.contentTimeout = setTimeout(() => {
            this.contentTarget.innerHTML = "";
        }, 0);

    }

    // hide modal on successful form submission
    // action: "turbo:submit-end->turbo-modal#submitEnd"
    submitEnd(e) {
        if (e.detail.success) {
            this.closeModal()
        }
    }

    // hide modal when clicking ESC
    // action: "keyup@window->turbo-modal#closeWithKeyboard"
    closeWithKeyboard(e) {
        if (e.code == "Escape") {
            if (this.modalTarget.dataset.turboModalOpened == "true") {
                this.closeModal();
            }
        }
    }
}