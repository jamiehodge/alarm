$(function() {

	$('#slideshow').show().cycle({ timeout: 12000 });
	
	$('body').noisy({
	    'noise' : 1, 
	    'tileSize' : 200, 
	    'backgroundColor' : '#BDC4C4', 
	    'maxNoiseOpacity' : 0.078, 
	    'fallbackImage' : '', 
	    'monochromatic' : false
	});
	
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
					$audioVideo.get(index + 1).play();
					location.href = '#' + $($audioVideo.get(index + 1)).closest('article').attr('id');
				});
			}
		});
		
		$('.playAll').click(function(event) {
			$audioVideo.each(function() {
				if (this.paused == false) {
					this.pause();
				}
			});
			$audioVideo.get(0).play();
			location.href = '#' + $audioVideo.first().closest('article').attr('id');
			event.preventDefault();
		});
	});

});