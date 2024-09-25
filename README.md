$(document).on('click', '.show-author', function(event) {
  event.preventDefault(); // Prevent the default link behavior

  var authorId = $(this).data('id'); // Get the author ID
  $.ajax({
    url: '/authors/' + authorId, // The URL to send the request to
    method: 'GET',
    dataType: 'script' // Expect JavaScript response
  });
});


$(document).on('click', '.delete-author', function(event) {
  event.preventDefault(); // Prevent the default link behavior

  var authorId = $(this).data('id'); // Get the author ID
  if (confirm("Are you sure you want to delete this author?")) { // Confirmation dialog
    $.ajax({
      url: '/authors/' + authorId, // The URL to send the request to
      method: 'DELETE',
      dataType: 'json', // Expect JSON response
      success: function(response) {
        if (response.status === 'ok') {
          // Remove the author element from the page, assuming each author has an element with id "author-#{authorId}"
          $('#author-' + authorId).remove();
        } else {
          alert('Failed to delete author.');
        }
      },
      error: function() {
        alert('Error deleting author.');
      }
    });
  }
});
