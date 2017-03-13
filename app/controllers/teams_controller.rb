class TeamsController < ApplicationController
  layout 'footer'
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  # GET /teams
  # GET /teams.json
  def index

    @teams = Team.all
    @users_included = Teamuser.select("distinct team_id").where(:user_id => current_user.id)
    @team_ids = []
    @users_included.each do |u|
      @team_ids.push(u.team_id)
    end

  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @teamusers = Teamuser.where(:team_id => params[:id])
    @ids = []
    @teamusers.each do |p|
      @ids.push(p.user_id)
    end  
    @userdetail = User.where(id: @ids) 
  end

  # GET /teams/new
  def new
    @team = Team.new
    @users = User.all
  end

  # GET /teams/1/edit
  def edit
    @teamusers = Teamuser.where(:team_id => params[:id])
    @ids = []
    @teamusers.each do |p|
      @ids.push(p.user_id)
    end  
    @userdetail = User.where(id: @ids) 
    @users = User.all
  end

  # POST /teams
  # POST /teams.json
  def create

    @team = Team.new(team_params)
    
    respond_to do |format|
      if @team.save
        teamuser_params.each do |tp|
          if tp.to_f > 0
            @team_user_entry = Teamuser.new
            @team_user_entry.team_id = @team.id
            @team_user_entry.user_id = tp
            @team_user_entry.save
          end
        end
      
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        Teamuser.where(team_id:@team.id).destroy_all
        teamuser_params.each do |tp|
          if tp.to_f > 0
            @team_user_entry = Teamuser.new
            @team_user_entry.team_id = @team.id
            @team_user_entry.user_id = tp
            @team_user_entry.save
          end
        end  
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    Teamuser.where("team_id = ?",params[:id]).destroy_all
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name,:manager)
    end
    def teamuser_params
      params[:team][:userss]
    end
end
