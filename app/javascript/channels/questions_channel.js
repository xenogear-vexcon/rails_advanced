import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    console.log('Questions connected')
  },

  disconnected() {
    console.log('Questions disconnected')
  },

  received(data) {
    var questions = $('.questions')
    questions.append(data['question'])
  }
});
