class PlaysController < ApplicationController
  before_action :set_play, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index

    ajax_action unless params[:ajax_handler].blank?
    @plays = Play.all
    respond_with(@plays)
  end

  def ajax_action

    p "dafafda"
    if params[:ajax_handler] == 'handle_name1'
      p "dafafda"
      # Ajaxの処理
      @data = Play.all
      if @data.size > 0
        render json: 'no data'
      else
        render json: 'no data'
      end
    end
  end



  def show
    respond_with(@play)
  end

  def new
    # @play = Play.new
    # respond_with(@play)
    @play = Play.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
  end

  def create


    # @play = Play.new(play_params)
    @play = Play.new(play_params)
    @play.save
    respond_with(@play)
   end

  def update
    @play.update(play_params)
    respond_with(@play)
  end

  def destroy
    @play.destroy
    respond_with(@play)
  end

  private
    def set_play
      @play = Play.find(params[:id])
    end

    def play_params
      params.require(:play).permit(:name)
    end
end
