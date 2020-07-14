import consumer from "./consumer"

consumer.subscriptions.create("AnswersChannel", {
  connected() {
    console.log('Answers connected')
  },

  disconnected() {
    console.log('Answers disconnected')
  },

  received(data) {
    var answers = $('.answers')
    answers.append(data)
  }
});
