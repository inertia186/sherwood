require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
  end
  
  def test_routings
    assert_routing({ method: 'get', path: 'users/new' }, controller: 'users', action: 'new')
    assert_routing({ method: 'post', path: 'users' }, controller: 'users', action: 'create')
  end
  
  def test_new
    process :new, method: :get
    user = assigns :user
    assert user, 'expect post'
    
    assert_template :new
    assert_response :success
  end
  
  def test_create
    process :create, method: :post, params: { user: user_params }
    user = assigns :user
    assert user.valid?, "expect valid user, got: #{user.errors.inspect}"
    
    assert_template nil
    assert_redirected_to dashboard_path
  end

  def test_create_invalid
    process :create, method: :post, params: { user: user_params.merge(nick: '') }
    user = assigns :user
    refute user.valid?, 'expect valid user'
    
    assert_template :new
    assert_response :success
  end
private
  def user_params
    {
      nick: 'Nick',
      email: 'nick@email.com',
      password: 'password',
      password_confirmation: 'password'
    }
  end
end
