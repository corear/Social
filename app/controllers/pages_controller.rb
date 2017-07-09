class PagesController < ApplicationController
  
  # back-end code for pages/index
  def index
  end
  
  # back-end code for pages/home
  def home
     @posts = Post.all
     @newPost = Post.new
  end

  # back-end code for pages/profile
  def profile
    if (User.find_by_username(params[:id]))
    @username = params[:id]
    else
    redirect_to root_path, :alert=> "User #{params[:id]} not found!"
    end
    
    @posts = Post.all.where('user_id = ?', User.find_by_username(params[:id]).id)
    @newPost = Post.new
  
  end

  # back-end code for pages/groups
  def groups
  end

  # back-end code for pages/prayers
  def prayers
     @posts = Post.all
  end
end
