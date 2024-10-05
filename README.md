h1>New User</h1>

<%= form_with model: @user, url: users_path, local: true, id: "user_form" do |form| %>
  <div>
    <%= form.label :first_name %>
    <%= form.text_field :first_name, id: "first_name" %>
  </div>

  <div>
    <%= form.label :last_name %>
    <%= form.text_field :last_name, id: "last_name" %>
  </div>

  <div>
    <%= form.label :username %>
    <%= form.text_field :username, id: "username", readonly: true %>
  </div>

  <div>
    <%= form.label "10th Marks" %>
    <%= form.number_field :tenth_marks %>
  </div>

  <div>
    <%= form.label "10th Passing Year" %>
    <%= form.select :tenth_year, (1990..2024).to_a.reverse, { include_blank: 'Select Year' }, id: "tenth_year" %>
  </div>

  <div>
    <%= form.label "12th Marks" %>
    <%= form.number_field :twelfth_marks %>
  </div>

  <div>
    <%= form.label "12th Passing Year" %>
    <%= form.select :twelfth_year, [], { include_blank: 'Select 10th Year First' }, id: "twelfth_year" %>
  </div>

  <div>
    <%= form.label :gender %>
    <%= form.select :gender, ['Male', 'Female', 'Other'] %>
  </div>

  <div>
    <%= form.submit "Create User" %>
  </div>
<% end %>

<!-- Inline jQuery Script -->
<script>
  $(document).ready(function() {
    // Username auto-generation based on first name and last name
    $('#first_name, #last_name').on('input', function() {
      var firstName = $('#first_name').val().trim().toLowerCase();
      var lastName = $('#last_name').val().trim().toLowerCase();

      if (firstName && lastName) {
        $('#username').val(firstName + '.' + lastName);
      }
    });

    // Dynamically populate 12th passing year based on 10th passing year
    $('#tenth_year').on('change', function() {
      var tenthYear = parseInt($(this).val());
      var $twelfthYear = $('#twelfth_year');
      
      // Clear previous options
      $twelfthYear.empty();

      if (!isNaN(tenthYear)) {
        var startYear = tenthYear + 2; // Assuming 12th is 2 years after 10th
        var currentYear = new Date().getFullYear();

        // Add a blank default option
        $twelfthYear.append($('<option>', { value: '', text: 'Select Year' }));

        // Generate options for 12th passing year
        for (var year = startYear; year <= currentYear; year++) {
          $twelfthYear.append($('<option>', { value: year, text: year }));
        }
      } else {
        // If no valid 10th year selected, reset the 12th year field
        $twelfthYear.append($('<option>', { value: '', text: 'Select 10th Year First' }));
      }
    });
  });
</script>
