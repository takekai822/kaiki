class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    if params[:sort_update]
      @books = Book.latest
    elsif params[:high_rate]
      @books = Book.high_rate
    else
      @books = Book.includes(:favorited_users).sort { |a,b| b.favorited_users.includes(:favorites).where(created_at: from...to).size <=> a.favorited_users.includes(:favorites).where(created_at: from...to).size }
    end
    @book = Book.new
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
    end
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book)
    else
      @books = Book.all
      render "index"
    end
  end

  def show
    @book = Book.find(params[:id])
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
    end
    @booknew = Book.new
    @book_comment = BookComment.new
  end

  def edit
  end

  def update
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book)
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private
  def book_params
    params.require(:book).permit(:title, :body, :rate)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    if @book.user != current_user
      redirect_to books_path
    end
  end
end
