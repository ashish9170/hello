<h1>Authors</h1>
<%= link_to 'New Author', new_author_path %>
<ul>
  <% @authors.each do |author| %>
    <li>
      <%= link_to author.name, author_path(author) %>
      <%= link_to 'Edit', edit_author_path(author) %>
      <%= link_to 'Delete', author_path(author), method: :delete, data: { confirm: 'Are you sure?' } %>
    </li>
  <% end %>
</ul>



<h1><%= @author.name %></h1>
<p><%= @author.bio %></p>

<h2>Books</h2>
<%= link_to 'New Book', new_author_book_path(@author) %>
<ul>
  <% @books.each do |book| %>
    <li>
      <%= link_to book.title, author_book_path(@author, book) %>
      <%= link_to 'Edit', edit_author_book_path(@author, book) %>
      <%= link_to 'Delete', author_book_path(@author, book), method: :delete, data: { confirm: 'Are you sure?' } %>
    </li>
  <% end %>
</ul>

<%= link_to 'Back', authors_path %>




<%= form_with model: @author do |f| %>
  <div>
    <%= f.label :name %>
    <%= f.text_field :name %>
  </div>
  <div>
    <%= f.label :bio %>
    <%= f.text_area :bio %>
  </div>
  <div>
    <%= f.submit %>
  </div>
<% end %>

<%= link_to 'Back', authors_path %>



<h1><%= @book.title %></h1>
<p><%= @book.description %></p>
<p>Price: <%= number_to_currency(@book.price) %></p>

<%= link_to 'Back', author_path(@book.author) %>




<%= form_with model: [@book.author, @book] do |f| %>
  <div>
    <%= f.label :title %>
    <%= f.text_field :title %>
  </div>
  <div>
    <%= f.label :description %>
    <%= f.text_area :description %>
  </div>
  <div>
    <%= f.label :price %>
    <%= f.number_field :price %>
  </div>
  <div>
    <%= f.submit %>
  </div>
<% end %>

<%= link_to 'Back', author_path(@book.author) %>





class AuthorsController < ApplicationController
  def index
    @authors = Author.all
  end

  def show
    @author = Author.find(params[:id])
    @books = @author.books
  end

  def new
    @author = Author.new
  end

  def create
    author = Author.new(author_params)
    if author.save
      redirect_to authors_path
    else
      render :new
    end
  end

  def edit
    @author = Author.find(params[:id])
  end

  def update
    author = Author.find(params[:id])
    if author.update(author_params)
      redirect_to author_path(author)
    else
      render :edit
    end
  end

  def destroy
    author = Author.find(params[:id])
    author.destroy
    redirect_to authors_path
  end

  private

  def author_params
    params.require(:author).permit(:name, :bio)
  end
end




class BooksController < ApplicationController
  before_action :set_author

  def show
    @book = @author.books.find(params[:id])
  end

  def new
    @book = @author.books.build
  end

  def create
    @book = @author.books.build(book_params)
    if @book.save
      redirect_to author_path(@author)
    else
      render :new
    end
  end

  def edit
    @book = @author.books.find(params[:id])
  end

  def update
    @book = @author.books.find(params[:id])
    if @book.update(book_params)
      redirect_to author_path(@author)
    else
      render :edit
    end
  end

  def destroy
    @book = @author.books.find(params[:id])
    @book.destroy
    redirect_to author_path(@author)
  end

  private

  def set_author
    @author = Author.find(params[:author_id])
  end

  def book_params
    params.require(:book).permit(:title, :description, :price)
  end
end
