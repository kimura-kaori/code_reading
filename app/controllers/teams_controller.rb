class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[show edit update destroy owner_change]

  def index
    @teams = Team.all
  end

  def show
    @working_team = @team
    change_keep_team(current_user, @team)
  end

  def new
    @team = Team.new
  end

  def edit
    redirect_to root_path unless @team.owner == current_user
  end

  def create
    @team = Team.new(team_params)
    @team.owner = current_user
    if @team.save
      @team.invite_member(@team.owner)
      redirect_to @team, notice: I18n.t('views.messages.create_team')
    else
      flash.now[:error] = I18n.t('views.messages.failed_to_save_team')
      render :new
    end
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: I18n.t('views.messages.update_team')
    else
      flash.now[:error] = I18n.t('views.messages.failed_to_save_team')
      render :edit
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_url, notice: I18n.t('views.messages.delete_team')
  end

  def dashboard
    @team = current_user.keep_team_id ? Team.find(current_user.keep_team_id) : current_user.teams.first
  end

  def owner_change
    # owner_idというキーがshow.html.erbから送られてきた:kimura_idの値を保持しており、その内容でupdateしている
    @team.update(owner_id: params[:kimura_id])
    if @team.save
      ChangeMailer.send_message_to_user(current_user).deliver
      redirect_to team_path, notice: 'オーナー権限が移動しました!'
    else
      render :new
    end
  end
  # binding.irb
  # @team = Team.find(params[:id])
  # @user = User.where(user_id: @team.id)
  # ここでチーム内のユーザー情報を取得したい

  # チームテーブルではオーナーidはあるけど、ユーザーidは持ってない
  # userとteamの中間テーブルがassign

  # 選択したユーザーをオーナーに代入する
  # @team.owner = assign.id

  private

  def set_team
    @team = Team.friendly.find(params[:id])
  end

  def team_params
    params.fetch(:team, {}).permit %i[name icon icon_cache owner_id keep_team_id]
  end

end
