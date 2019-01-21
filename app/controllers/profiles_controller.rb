class ProfilesController < ApplicationController
  before_action :set_profile, only: [:edit, :show]
  before_action :update_profile, only: [:update]
  def show   
    @user = User.find(params[:id])
    @profile = @user.profile
  end

  def edit
    @profile = @user.profile
  end

  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)
    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render action: 'show', status: :created, location: @profile }
      else
        format.html { render action: 'new' }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @profile.update(profile_params)
       redirect_to root_path, notice: 'Updated user profile successfully.'
    else
       render action: 'edit'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @user = User.find(params[:id])
      @profile = @user.profile
    end

    def update_profile
      @profile = Profile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:name, :bio, :birthday, :twitter)
    end
end
