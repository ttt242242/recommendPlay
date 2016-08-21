require 'test_helper'

class PlaysControllerTest < ActionController::TestCase
  setup do
    @play = plays(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plays)
  end

  test "should post index" do
    post :index , post:{word: "テニス"}

    
    assert_response :success
    assert_not_nil assigns(:plays)
  end

  
  test "should create play" do
    assert_difference('Play.count') do
      post :create, play: { name: @play.name }
    end

    assert_redirected_to play_path(assigns(:play))
  end

  test "should show play" do
    get :show, id: @play
    assert_response :success
  end


  test "should update play" do
    patch :update, id: @play, play: { name: @play.name }
    assert_redirected_to play_path(assigns(:play))
  end

  test "should destroy play" do
    assert_difference('Play.count', -1) do
      delete :destroy, id: @play
    end

    assert_redirected_to plays_path
  end
end
