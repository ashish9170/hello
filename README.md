<h1>Authors</h1>

<div id="authors-list">
  <%= render partial: 'author', collection: @authors %>
</div>
<%= form_with(model: @new_author, id: 'new_author', local: true) do |form| %>
  <% if @new_author.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(@new_author.errors.count, "error") %> prohibited this author from being saved:</h2>
      <ul>
        <% @new_author.errors.full_messages.each do |message| %>
          <li><%= message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div class="field">
    <%= form.label :name %>
    <%= form.text_field :name %>
  </div>

  <div class="field">
    <%= form.label :bio %>
    <%= form.text_area :bio %>
  </div>

  <div class="actions">
    <%= form.submit %>
  </div>
<% end %>

<script>
  $(document).ready(function() {
    $('#new_author').on('submit', function(event) {
      event.preventDefault();

      $.ajax({
        url: $(this).attr('action'),
        type: 'POST',
        data: $(this).serialize(),
        dataType: 'script',
        success: function(response) {
          // handle successful response
        },
        error: function(xhr, status, error) {
          // handle error response
        }
      });
    });
  });
</script>


<% if @new_author.errors.any? %>
  alert("Failed to create author: <%= j @new_author.errors.full_messages.join(", ") %>");
<% else %>
  $('#authors-list').append('<%= j render(@new_author) %>');
  $('#new_author')[0].reset();
<% end %>

<% if @author.errors.any? %>
  alert("Failed to update author: <%= j @author.errors.full_messages.join(", ") %>");
<% else %>
  $('#author_<%= @author.id %>').replaceWith('<%= j render(@author) %>');
<% end %>





class AuthorsController < ApplicationController
  before_action :set_author, only: [:show, :edit, :update, :destroy]

  def index
    @new_author = Author.new
    @authors = Author.all
  end

  def create
    @new_author = Author.new(author_params)
    if @new_author.save
      respond_to do |format|
        format.html { redirect_to authors_path, notice: 'Author was successfully created.' }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :index }
        format.js
      end
    end
  end

  def update
    if @author.update(author_params)
      respond_to do |format|
        format.html { redirect_to authors_path, notice: 'Author was successfully updated.' }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @deleted_author = @author.destroy
    respond_to do |format|
      format.html { redirect_to authors_url, notice: 'Author was successfully destroyed.' }
      format.js
    end
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name, :bio)
  end
end
<div id="author_<%= author.id %>">
  <p>
    <strong>Name:</strong>
    <%= author.name %>
  </p>
  <p>
    <strong>Bio:</strong>
    <%= author.bio %>
  </p>

  <%= link_to 'Edit', edit_author_path(author) %> |
  <%= link_to 'Destroy', author, method: :delete, data: { confirm: 'Are you sure?' } %>
</div>











