(function($){
	$editable = $('*[contenteditable]');
	
	$editable.focus(function() {
		localStorage.setItem('undo', this.innerHTML);
		$(this).addClass('edit');
	});
	
	$editable.blur(function() {
		$field = $(this);
		$field.removeClass('edit');
		if (localStorage.getItem('undo') != $field.text()) {
			if (confirm("Save changes to " + $field.attr('class') + '?')) {
				$.ajax({
					type: 'put',
					url: localStorage.getItem('base_url') + $field.closest('article').attr('class') + 's/' + $field.closest('article').attr('id'),
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
	
	if (!Modernizr.audio) {
		$audioVideo = $('audio, video');

		$audioVideo.each(function(index) {
			if (index < ($audioVideo.length - 1)) {
				$(this).bind('ended', function() {
					$audioVideo.get(index + 1).play();
					location.href = '#' + $($audioVideo.get(index + 1)).closest('article').attr('id');
				});
			}
		});

		$('button.play_all').click(function(event) {
			$audioVideo.each(function() {
				if (this.paused == false) {
					this.pause();
				}
			});
			$audioVideo.get(0).play();
			location.href = '#' + $audioVideo.first().closest('article').attr('id');
			event.preventDefault();
		});
	}
	
	$('input, textarea').blur(function() {
		if (this.willValidate && !this.validity.valid) {
			$(this).removeClass('valid');
			$(this).addClass('error');
		} else {
			$(this).removeClass('error');
			$(this).addClass('valid');
		}
	});
	
	$('form').submit(function() {
		return ($(this).has('input:required:invalid, textarea:required:invalid').length ? false : true);
	});
	
})(this.jQuery);