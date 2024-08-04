document.addEventListener('DOMContentLoaded', function() {
  document.querySelector('.confirm-button').addEventListener('click', function() {
    const requestId = this.dataset.requestId;
    const description = document.querySelector('#sample_input').value;

    fetch(`/requests/${requestId}/update_status`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        status: 'cancel',  // hoặc "approve' tùy vào logic của bạn
        description: description
      })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        location.reload();
      } else {
        console.error('Update failed:', data.errors);
      }
    })
    .catch(error => {
      console.error('Error:', error);
    });
  });
});
