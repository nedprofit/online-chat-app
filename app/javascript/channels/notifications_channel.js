import consumer from "./consumer"

document.addEventListener('turbo:load', () => {
    const notificationElement = document.querySelector('[data-controller="notification"]');

    consumer.subscriptions.create("NotificationsChannel", {
        received(data) {
            if (notificationElement) {
                displayNotification(notificationElement, data.chat_name, data.message_body);
            }
            playNotificationSound();
        }
    });
});


function displayNotification(element, chatName, messageBody) {
    const customEvent = new CustomEvent("showNotification", {
        bubbles: true,
        detail: {
            chat_name: chatName,
            message_body: messageBody
        },
    });

    element.dispatchEvent(customEvent);
}


function playNotificationSound() {
    console.log("123")
    const audio = new Audio('/audios/icq-message.wav');
    audio.play().catch(e => console.error("Не удалось воспроизвести звук: ", e));
}
