$(document).on('turbolinks:load', function() {

	$('.change-rating').on('ajax:success', function(e) {
		var questionId = this.dataset.questionId;
		var rank = e.detail[0];
		$('.rating[data-question-id="' + questionId + '"]').html("");
		$('.rating[data-question-id="' + questionId + '"]').prepend("Rating: " + rank);
	})

	$('.change-rating').on('ajax:success', function(e) {
		var answerId = this.dataset.answerId;
		var rank = e.detail[0];
		$('.rating[data-answer-id="' + answerId + '"]').html("");
		$('.rating[data-answer-id="' + answerId + '"]').prepend("Rating: " + rank);
	})
})