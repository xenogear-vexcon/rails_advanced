import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    console.log('Connected to questions channel.')
  },

  disconnected() {
    console.log('Questions channel disconnected.')
  },

  received(data) {
    var questions = $('.questions')
    questions.append(data['question'])
  }
});
