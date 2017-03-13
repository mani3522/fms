class EventsController < ApplicationController
  layout 'footer'
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  helper_method :sort_column, :sort_direction

  # GET /events
  # GET /events.json
  def index
    @events = Event.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /events/1
  # GET /events/1.json
  def show
    
    @eventusers = Eventuser.where(:event_id => params[:id])
    @teamevents = Teamevent.where(:event_id => params[:id])

    @ids = []
    @eventusers.each do |p|
      @ids.push(p.user_id)
    end  
    @userdetail = User.where(id: @ids) 

    @team_ids = []
    @teamevents.each do |p|
      @team_ids.push(p.team_id)
    end
    @teamdetail = Team.where(id: @team_ids) 
    @teamcount  = Teamuser.where(team_id: @team_ids).group(:team_id).count
    @team_response = Teamuser.joins("JOIN Eventusers ON Teamusers.user_id = Eventusers.user_id").
                      select("Eventusers.user_id").where(team_id: @team_ids).
                      where("Eventusers.status = 1 AND Eventusers.event_id = ?",params[:id]).group(:team_id).count
    

    @accepted_count = []
    @declined_count = []
    @eventusers.each do |eu|
      if eu.status == 1
        @accepted_count.push(eu.user_id)
      elsif eu.status == 2
        @declined_count.push(eu.user_id)
      end
    end

    @invitation = {}
    @invitation['total_users'] = @eventusers.length
    @invitation['total_teams'] = @teamevents.length
    @invitation['total_accepted'] = @accepted_count
    @invitation['total_declined'] = @declined_count
  end

  # GET /events/new
  def new
    @event = Event.new
    @teams = Team.all
    @users = User.all
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    user_ids = []
    respond_to do |format|
      if @event.save
        team_event_params.each do |te|
          if te.to_f > 0

            @team_event_entry = Teamevent.new
            @team_event_entry.event_id = @event.id
            @team_event_entry.team_id = te
            @team_event_entry.save

            @team_users = Teamuser.select("user_id").where(:team_id => te)
            
            

            @team_users.each do |tu|
              unless user_ids.include? tu.user_id.to_s
                user_ids.push(tu.user_id.to_s)
              end
            end
          end
        end

        event_user_params.each do |te|
          if te.to_i > 0
            unless user_ids.include? te  
              user_ids.push(te)
            end
          end
        end

        

        user_ids.each do |ui|
          @event_user_entry = Eventuser.new
          @event_user_entry.event_id = @event.id
          @event_user_entry.user_id = ui
          @event_user_entry.status = 0 # 0-pend , 1-accept , 2 - reject , 3 - event expired
          @event_user_entry.save
        end

        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    Eventuser.where("event_id = ?",params[:id]).destroy_all
    Teamevent.where("event_id = ?",params[:id]).destroy_all

    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :startime, :endtime, :amount, :venue)
    end
    def team_event_params
      params[:event][:teamss]
    end
    def event_user_params
      params[:event][:userss]
    end

    def sort_column
      Event.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
