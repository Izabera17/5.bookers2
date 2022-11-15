class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit]

  def new
    @user_image = User.new
  end

  def index
    @user = User.all
    @users = User.new

    @user_id = current_user

    @book = Book.all
    @books = Book.new
  end

  def create
    @books = Book.new(user_params)
    @books.user_id = current_user.id

    if @books.save
        flash[:notice]="You have updated user successfully."
        redirect_to book_path(@book.id)
    else
        @books =Book.all
        @user = current_user
        render :show
    end
  end

  def show
    @user = User.all
    @users = User.new

    @book = Book.all
    @books = Book.new

    @user_id =  User.find(params[:id])

    @book_id = @user_id.books

  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_image_params)
      redirect_to user_path(@user.id)
      flash[:notice] = "You have updated user successfully."
    else
      render :edit
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  private

  def user_image_params
    params.require(:user).permit(:name, :introduction, :user_id, :profile_image)
  end

  def user_params
    params.require(:user).permit(:title, :body, :user_id, :image)
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(user_path(current_user.id)) unless @user == current_user
  end

end
