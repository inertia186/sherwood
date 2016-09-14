require 'test_helper'

class AuthorsControllerTest < ActionController::TestCase
  def setup
    @project = projects(:gi)
    gilligan = users(:gilligan)
    gilligan.projects << @project
    user_sign_in(gilligan)
  end
  
  def test_routings
    assert_routing({ method: 'get', path: 'projects/99/authors' }, controller: 'authors', action: 'index', project_id: '99')
  end
  
  def test_index
    stub_post_get_content times: 2 do
      @project.posts.map(&:content!)
    end
    
    @project.posts.update_all("updated_at = '#{20.days.ago}'")
      
    stub_post_get_accounts times: 2 do
      process :index, method: :get, params: { project_id: @project }
    end
    authors = assigns :authors
    assert authors, 'expect authors'
    # assert authors.any?, 'expect authors'
    
    assert_template :index
    assert_response :success
  end
end
