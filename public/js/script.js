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
		$field = $(this);
		$field.removeClass('edit');
		if (localStorage.getItem('undo') != $field.text()) {
			if (confirm("Save changes to " + $field.attr('class') + '?')) {
				$.ajax({
					type: 'put',
					url: localStorage.getItem('base_url') + '/feeds/' + $field.closest('article').attr('id'),
					data: { property_name: $field.attr('class'), property_value: $field.text() },
					success: function() {
						alert('Saved changes to ' + $field.attr('class'));
					},
					error: function() {
						alert('Failed to save changes to ' + $field.attr('class'));
						$field.text(localStorage.getItem('undo'));
					}
				});
			} else {
				$field.text(localStorage.getItem('undo'));
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