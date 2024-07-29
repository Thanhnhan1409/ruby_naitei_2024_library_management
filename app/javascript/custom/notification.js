$(document).on('turbolinks:load', function() {
  $('.add-to-cart-form').on('submit', function(event) {
    event.preventDefault();
    var $form = $(this);
    $.ajax({
      url: $form.attr('action'),
      method: $form.attr('method'),
      data: $form.serialize(),
      success: function(response) {
        $('#flash-messages').html('<div class="alert alert-success">' + response.message + '</div>');
      },
      error: function(response) {
        $('#flash-messages').html('<div class="alert alert-danger">' + response.responseJSON.message + '</div>');
      }
    });
  });
});
