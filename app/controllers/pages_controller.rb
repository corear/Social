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
  
  def send_custom
    UserMailer.send_custom(params[:user],current_user.email,params[:subject],params[:message]).deliver
    redirect_to "/home", :notice => "The email has been sent."
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
  
  def list
    if (User.find_by_username(params[:id]))
    @username = params[:id]
    else
    redirect_to root_path, :alert=> "User #{params[:id]} not found!"
    end
    
    @hot = nil
    
    if params[:type] == "followers" then
      @hot = User.find_by_username(params[:id]).followers
    elsif params[:type] == "following" then
      @hot = User.find_by_username(params[:id]).following
    end

    
    @posts = Post.all.where('user_id = ?', User.find_by_username(params[:id]).id)
    @newPost = Post.new
    @users = User.all.where('id != ?', current_user.id).sort_by { |u| -u.followers.count }.take(100).sample(3)
  
  end
  
  def search_handler
    @query = params[:id]
    @type = params[:id1]
    if @type == 'users'
      @users = User.where('lower(username) LIKE ?', "%#{@query.downcase}%").sort_by { |u| -u.followers.count }.take(50)
    end
    if @type == 'posts'
      @posts = Post.where('lower(content) LIKE ?', "%#{@query.downcase}%").order("created_at DESC").take(50)
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
