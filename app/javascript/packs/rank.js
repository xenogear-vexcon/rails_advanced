$(document).on('turbolinks:load', function() {

	$('.rank').on('ajax:success', function(e) {
		console.log(e.detail[0]);
		var object = e.detail[0]["object"].toLowerCase();
		var id = e.detail[0]["id"]
		var rating = e.detail[0]["rating"];
		var result = e.detail[0]["rank_result"];
		var ratingInfo = $('.rating[id="' + object + '_' + id + '"]');
		ratingInfo.html("");
		ratingInfo.prepend("Rating: " + rating);

		var result_message = $('.result[id="' + object + '_' + id + '"]');
		var upRankButton = $('.change-rank-up[id="' + object + '_' + id + '"]');
		var downRankButton = $('.change-rank-down[id="' + object + '_' + id + '"]');
		if (result == 1) {
			result_message.html("You voted positive")
			upRankButton.hide()
			downRankButton.show()
		} else if (result == -1) {
			result_message.html("You voted negative")
			upRankButton.show()
			downRankButton.hide()
		} else if (result == 0) {
			result_message.html("")
			upRankButton.show()
			downRankButton.show()
		}
	})
})
