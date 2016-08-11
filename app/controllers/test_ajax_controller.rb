class TestAjaxController < ApplicationController
  def index
    @greeting = params[:greeting]
    render
  end
end
