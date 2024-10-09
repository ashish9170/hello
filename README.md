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
class TasksController < ApplicationController
  before_action :authenticate_user!

  def edit
    @task = Task.find(params[:id])
    @users = User.all

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @task = Task.new
    @users = User.all
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      @tasks = Task.all.includes(:assigned_user)
      @type1 = Task.where(status: "Open")
      @type2 = Task.where(status: "Closed")
      respond_to do |format|
        format.html { redirect_to tasks_path, notice: 'Task was successfully updated.' }
        format.js   # AJAX request
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js   # AJAX request
      end
    end
  end

  def index
    @tasks = Task.all.includes(:assigned_user)
    @task = Task.new
    @type1 = Task.where(status: "Open")
    @type2 = Task.where(status: "Closed")
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :task_type, :status, :assigned_user_id)
  end
end
div style="background-color: yellow; padding: 20px;">
  <div class="table-responsive" style="margin-left: 20px;">
    <table class="table">
      <thead class="table-dark">
        <tr>
          <th scope="col">Title</th>
          <th scope="col">Description</th>
          <th scope="col">Task Type</th>
          <th scope="col">Status</th>
          <th scope="col">Assigned By</th>
          <th scope="col">Assigned To</th>
          <th scope="col">Actions</th>
        </tr>
      </thead>
      <tbody>
        <% @tasks.each do |task| %>
          <tr id="task_<%= task.id %>">
            <td><%= task.title %></td>
            <td><%= task.description %></td>
            <td><%= task.task_type %></td>
            <td><%= task.status %></td>
            <td><%= task.user.email %></td>
            <td><%= task.assigned_user.email %></td>
            <td>
              <%= link_to "Edit", edit_task_path(task), remote: true, class: 'btn btn-warning' %>
            </td>
          </tr>
        <% end %>
      </tbody>
    </table>
  </div>
</div>
<div class="form_new"></div
