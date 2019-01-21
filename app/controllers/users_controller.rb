class UsersController < ApplicationController
    before_action :authenticate, only: [:index, :edit, :update]
    before_action :create_profile
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    def index
        @users = User.all.paginate(:per_page => 10, :page => params[:page])
    end

    def new
        @user = User.new
    end
    
    def create
        @user = User.new(user_params)
        @user.profile = @profile
        if @user.save
            redirect_to root_path, notice: 'User successfully added.'
        else
            render action: :new
        end
    end
    
    def edit
        @user = current_user
    end

    def modify
        @user = current_user
    end

    def show
        @user = User.find(params[:id])
    end
    
    def update
        if @user.update(user_params)
            redirect_to root_path, notice: 'Updated user information successfully.'
        else
            render action: 'edit'
        end
    end
    
    private
    def set_user
        @user = current_user
    end
    
    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def create_profile
        @profile = Profile.create(:name => "Name",:bio => "Bio",:birthday => "Birthday",:twitter => "TwitterHandle")
    end
end
