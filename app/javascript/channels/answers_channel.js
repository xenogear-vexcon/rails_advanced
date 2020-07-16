import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  $('.new-answer').on('ajax:error', function (e) {

    var errors = e.detail[0]
    $.each(errors, function(index, value) {
      $('.answer-errors').append("<div class='alert alert-danger alert-dismissible fade show' role='alert'>" + value
        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button></div>")
    })
  })


  const element = document.getElementById('question_id')
  const question_id = element.getAttribute('data-question-id')

  consumer.subscriptions.create({ channel: "AnswersChannel", question_id: question_id }, {
    connected() {
      console.log('Question ' + question_id + ' answers connected')
    },

    disconnected() {
      console.log('Question ' + question_id + ' answers disconnected')
    },

    received(data) {
      var answers = $('.answers')
      answers.append(data['answer'])
      var answerBody = $('#answer_body')
      answerBody.val('')
    }
  });
});
