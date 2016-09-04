require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def test_routings
    assert_routing({ method: 'get', path: 'session/new' }, controller: 'sessions', action: 'new')
    assert_routing({ method: 'post', path: 'session' }, controller: 'sessions', action: 'create')
    assert_routing({ method: 'delete', path: 'session' }, controller: 'sessions', action: 'destroy')
    assert_routing({ method: 'delete', path: 'session.js' }, controller: 'sessions', action: 'destroy', format: 'js')
  end
  
  def test_new
    process :new, method: :get
    
    assert_template :new
    assert_response :success
  end
  
  def test_create
    project = projects(:rhw)
    return_to = "http://test.host/projects/#{project.to_param}/posts"
    process :create, method: :post, params: { email: 'willyg@minnow.com', password: 'password', return_to: return_to }
    
    assert_template nil
    assert_redirected_to project_posts_url(project)
  end

  def test_create_wrong
    project = projects(:rhw)
    process :create, method: :post, params: { email: 'willyg@minnow.com', password: 'WRONG' }
    
    assert_template :new
    assert_response :success
  end
  
  def test_destroy
    user_sign_in(users(:gilligan))
    process :destroy, method: :delete
    refute session[:user_id]
    
    assert_template nil
    assert_redirected_to dashboard_url
  end
end
