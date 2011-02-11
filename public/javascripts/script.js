$(function() {

	$('#slideshow').show().cycle({ timeout: 12000 });
	
	$('details').collapse({ 
		head: 'summary', 
		group: 'section',
		show: function() { this.animate({opacity: 'toggle', height: 'toggle'}, 200); },
		hide : function() { this.animate({opacity: 'toggle', height: 'toggle'}, 200); },
		cookieName: $(location).attr('pathname')
	});
	
	$audioVideo = $('audio, video');
	
	$(function() {
		
		$audioVideo.each(function(index) {
			if (index < ($audioVideo.length - 1)) {
				$(this).bind('ended', function() {
					$audioVideo[index + 1].play();
					location.href = '#' + $($audioVideo[index + 1]).closest('article').attr('id');
				});
			}
		});
		
		$('.playAll').click(function(event) {
			$audioVideo.each(function() {
				this.pause();
			});
			$audioVideo[0].play();
			location.href = '#' + $audioVideo.first().closest('article').attr('id');
			event.preventDefault();
		});
	});

});