class PagesController < ApplicationController
  
  # back-end code for pages/index
  def index
  end
  
  # back-end code for pages/home
  def home
     @posts = Post.all
     @newPost = Post.new
     @users = User.all.where('id != ?', current_user.id).sort_by { |u| -u.followers.count }.take(100).sample(3)
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
     @users = User.all.where('id != ?', current_user.id).sort_by { |u| -u.followers.count }.take(100).sample(3)
  
  end
  
  def search_handler
    @query = params[:id]
    @type = params[:id1]
    if @type == 'users'
      @users = User.where('username LIKE ?', "%#{@query}%").sort_by { |u| -u.followers.count }.take(50)
    end
    if @type == 'posts'
      @posts = Post.where('content LIKE ?', "%#{@query}%").order("created_at DESC").take(50)
    end
  end
  

  # back-end code for pages/groups
  def groups
  end

  # back-end code for pages/prayers
  def posts
     @users = User.all.where('id != ?', current_user.id).sort_by { |u| -u.followers.count }.take(100).sample(3)
     @posts = Post.all
  end
  
  def postpage
    if (Post.find(params[:id]))
    @post = params[:id]
    @p = Post.find(params[:id])
    @comments = Comment.where(post_id: @post).order("created_at DESC")
    else
    redirect_to root_path, :alert=> "That post does not exist!"
    end
    @arr = Post.find(params[:id]).content.split.find_all{|word| /^#.+/.match word}
  end
end
