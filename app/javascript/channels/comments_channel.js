import consumer from "./consumer"

consumer.subscriptions.create("CommentsChannel", {
  connected() {
    console.log('Comments connected')
  },

  disconnected() {
    console.log('Comments disconnected')
  },

  received(data) {
    var comments = $('.' + data.commentable_class)
    comments.append(data.comment)
    var commentBody = $('#comment_body')
    commentBody.val('')
  }
});
