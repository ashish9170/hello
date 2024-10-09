<% if @task.previous_changes[:status] %>
  // Remove the task row from the old status table
  $('#open_task_<%= @task.id %>').remove();
  $('#closed_task_<%= @task.id %>').remove();
<% end %>

// Update the task row in the all tasks table
$("#task_<%= @task.id %>").replaceWith("<%= j render(partial: 'task_row', locals: { task: @task }) %>");

// Add the task row to the new status table
<% if @task.status == 'Open' %>
  $("#type1 tbody").append("<%= j render(partial: 'task_row', locals: { task: @task }) %>");
<% elsif @task.status == 'Closed' %>
  $("#type2 tbody").append("<%= j render(partial: 'task_row', locals: { task: @task }) %>");
<% end %>
