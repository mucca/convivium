require 'test_helper'

class ExpensegroupsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:expensegroups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create expensegroup" do
    assert_difference('Expensegroup.count') do
      post :create, :expensegroup => { }
    end

    assert_redirected_to expensegroup_path(assigns(:expensegroup))
  end

  test "should show expensegroup" do
    get :show, :id => expensegroups(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => expensegroups(:one).to_param
    assert_response :success
  end

  test "should update expensegroup" do
    put :update, :id => expensegroups(:one).to_param, :expensegroup => { }
    assert_redirected_to expensegroup_path(assigns(:expensegroup))
  end

  test "should destroy expensegroup" do
    assert_difference('Expensegroup.count', -1) do
      delete :destroy, :id => expensegroups(:one).to_param
    end

    assert_redirected_to expensegroups_path
  end
end
