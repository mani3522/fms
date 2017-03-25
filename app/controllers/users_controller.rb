class UsersController < ApplicationController
  layout :resolve_layout

  before_action :logged_in_user, only: [:show, :destroy,:edit,:update]
  before_action :set_user, only: [:show, :destroy,:edit,:update]

  helper_method :sort_column, :sort_direction

  def index
    # @users = User.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])
    @users = User.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  # - Handles the user accept invite ajax

  def user_event_handle

    Eventuser.where(:event_id => params[:event_id]).where(:user_id =>current_user.id).update_all(:status => params[:status])
    data = {
      :status => params[:status]
    }

    respond_to do |format|
      format.all { render :json => data}
    end
  end


  def update_event_archive

    Eventuser.joins("INNER JOIN events ON eventusers.event_id = events.id")
    .where('eventusers.user_id = ? and eventusers.status != 3 and  events.endtime < ?',current_user.id,DateTime.now)
    .update_all(:status => 3)

  end


  # GET /users/1
  # GET /users/1.json
  def show

    # update_event_archive
    @all_event_details = []
    @event_accepts = {}

    # Get all the Events for the user
    @events = Eventuser.joins("LEFT OUTER JOIN events ON events.id = eventusers.event_id").where('user_id = ?',params[:id]).order('events.startime desc')

    @pending_invites = 0

    # Get details for those Event
    @events.each do |e|
      @event_accepts[e.event_id] = e.status # Display status in User view page
      @event_array = Event.find(e.event_id)
      if e.status == 0 && @event_array.endtime > DateTime.now
        @pending_invites = @pending_invites + 1
      end
      @all_event_details.push(@event_array)
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit

  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        UserMailer.welcome_email(@user).deliver
        log_in @user
        format.html { redirect_to @user, notice: 'Welcome to FreshEvent !!' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|

      # params[:user].delete(:password) if params[:user][:password].blank?
      if @user.update_attributes(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    # Teamuser.where("user_id = ?",params[:id]).destroy_all
    # Eventuser.where("user_id =?",params[:id]).destroy_all
    # binding.pry
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      UserMailer.logged_in(@user).deliver
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name,:email,:empid,:category, :dateofbirth, :gender, :teamid, :password, :password_confirmation)
    end


    def update_user_params
      params.require(:user).permit(:name,:email,:empid,:category, :dateofbirth, :gender)
    end

    #Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def resolve_layout
      case action_name

      when "show","edit","index"
        "footer"
      else
        "application"
      end
    end

    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
