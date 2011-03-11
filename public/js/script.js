(function($){
	$('details').collapse({ 
		head: 'summary', 
		group: 'section',
		show: function() { this.animate({opacity: 'toggle', height: 'toggle'}, 200); },
		hide : function() { this.animate({opacity: 'toggle', height: 'toggle'}, 200); },
		cookieName: $(location).attr('pathname')
	});
	
	$audioVideo = $('audio, video');
	
	$audioVideo.each(function(index) {
		if (index < ($audioVideo.length - 1)) {
			$(this).bind('ended', function() {
				$audioVideo.get(index + 1).play();
				location.href = '#' + $($audioVideo.get(index + 1)).closest('article').attr('id');
			});
		}
	});
	
	$('button').click(function(event) {
		$audioVideo.each(function() {
			if (this.paused == false) {
				this.pause();
			}
		});
		$audioVideo.get(0).play();
		location.href = '#' + $audioVideo.first().closest('article').attr('id');
		event.preventDefault();
	});
	
})(this.jQuery);