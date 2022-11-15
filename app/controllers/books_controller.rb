class BooksController < ApplicationController
    before_action :authenticate_user!
    before_action :is_matching_login_user, only: [:edit, :update]
    before_action :correct_user, only: [:edit]
  
  
  def new
    @book = Book.new
    @books = Book.all
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    
    if @book.save
      flash[:notice]="You have updated user successfully."
      redirect_to book_path(@book.id)
    else
      @books =Book.all
      @user = current_user
      render :new
    end
  end

  def index
    @books = Book.all
    @book = Book.new
    
    @user = User.all
    @users = User.new
    
    @user_id = User.find(current_user.id)

   
  end

  def show
    @books = Book.all
    @book = Book.new
    
    @book_id = Book.find(params[:id])
    @user_id = User.find(@book_id.user_id)
    @user_id_auth = @book_id.user.id 
    @user_id_name = @book_id.user.name
    
    @user = User.all
    @users = User.new
  end
  
  def edit
    @book = Book.find(params[:id])
  end
  
  def update
    @book = Book.find(params[:id])
    
    if @book.update(book_params)
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book) 
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])  
    @book.destroy  
    redirect_to books_path
  end
  
  def book_params
    params.require(:book).permit(:title, :body)
  end
  
  private 
  
  def user_params
    params.require(:user).permit(:name, :introduction, :image, :user_id)
  end
  
  def is_matching_login_user
    book = Book.find(params[:id])
    user_id = book.user.id 
    login_user_id = current_user.id
    if(user_id != login_user_id)
      redirect_to books_path
    end
  end
  
  def correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    redirect_to(user_path(current_user.id)) unless @user == current_user
  end
  
end
