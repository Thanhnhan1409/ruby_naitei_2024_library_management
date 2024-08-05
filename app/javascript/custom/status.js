document.addEventListener('DOMContentLoaded', function() {
  // Thêm event listener cho tất cả các nút có class "confirm-button"
  document.querySelectorAll('.confirm-button').forEach(button => {
    button.addEventListener('click', function() {
      const requestId = this.dataset.requestId;
      const action = this.dataset.action;
      const description = document.querySelector('#sample_input').value;

      fetch(`/requests/${requestId}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          status: action,
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
});
