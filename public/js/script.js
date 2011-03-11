(function($){
	$('details').collapse({ 
		head: 'summary', 
		group: 'section',
		show: function() { this.animate({opacity: 'toggle', height: 'toggle'}, 200); },
		hide : function() { this.animate({opacity: 'toggle', height: 'toggle'}, 200); },
		cookieName: $(location).attr('pathname')
	});
	
	$editable = $('*[contenteditable]');
	
	$editable.focus(function() {
		$(this).addClass('edit');
		localStorage.setItem('undo', this.innerHTML);
	});
	
	$editable.blur(function() {
		$(this).removeClass('edit');
		if (localStorage.getItem('undo') != $(this).text()) {
			if (confirm("Save changes to " + $(this).attr('class') + '?')) {
				$.post('' + $(this).closest('article').attr('id'), 
					{ property_name: $(this).attr('class'), property_value: $(this).text() });
			} else {
				$(this).text(localStorage.getItem('undo'));
			}
		}
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