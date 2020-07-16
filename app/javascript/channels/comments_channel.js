import consumer from "./consumer"

$(document).on('turbolinks:load', function() {

  $('.new-comment').on('ajax:error', function (e) {

    var errors = e.detail[0]

    console.log(e)
    $.each(errors, function(index, value) {
      $('[class*="_comment_errors"]').append("<div class='alert alert-danger alert-dismissible fade show' role='alert'>" + value
        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button></div>")
    })
  })

  const element = document.getElementById('question_id')
  const question_id = element.getAttribute('data-question-id')

  consumer.subscriptions.create({channel: "CommentsChannel", question_id: question_id, commentable_id: gon.commentable_id }, {
    connected() {
      console.log('Question ' + question_id + ' comments connected')
    },

    disconnected() {
      console.log('Question ' + question_id + ' comments disconnected')
    },

    received(data) {
      var comments = $('.' + data['commentable_class'])
      comments.append(data['comment'])
      var commentBodys = $('[id=comment_body]')
      for(var i=0; i<commentBodys.length; i++) {
        commentBodys[i].value = ''
      }
    }
  })
})
