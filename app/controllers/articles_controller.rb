class ArticlesController < ApplicationController
  
  # The Rails Major Rule Says, "NEVER REPEAT YOUR SELF", and you are exactly doing it here, defining the @article in every action, its not the best practice, we have to defined our code on a one place and then used it everywhere, so I Just add the actions in my before_action call so they can perform the Job and follow the Rails guidelines along with it
  
  # Further More I suggest you to Create the Controller by yourself rather than scaffold generator, becuase it also add the Additional files and it never been a good Practice in Rails
  
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :authenticate, except: [:index, :show]

  def index
    @articles = Article.all.paginate(:per_page => 6, :page => params[:page])
    @categories = Category.all 
    @users = User.all
    if params[:search]
      @articles = Article.search(params[:search]).order("created_at DESC").paginate(:per_page => 6, :page => params[:page])
    else
      @articles = Article.order("created_at DESC").paginate(:per_page => 6, :page => params[:page])
    end
  end

  # Users never be displayed on the Show Page of Some Record like here Article, in the Show Page of Article we are just show the Article, although if there is a requirement to show then we can do this, but in general Article show page actually contains the Related Articles not the Users.
  
  def show
    @users = User.all
  end

  def new
    @article = Article.new
  end

  def edit
  end
  
  def create
    @article = current_user.articles.new(article_params)
    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Thread was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Thread was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Thread was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :location, :excerpt, :body, :published_at, :category_ids => [])
    end
    
end
