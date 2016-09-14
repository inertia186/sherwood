require 'test_helper'

class PublicPostsControllerTest < ActionController::TestCase
  def setup
    @project = projects(:gi)
  end
  
  def test_routings
    assert_routing({ method: 'get', path: 'public_posts' }, controller: 'public_posts', action: 'index')
    assert_routing({ method: 'get', path: 'projects/99/public_posts' }, controller: 'public_posts', action: 'index', project_id: '99')
  end
  
  def test_index
    stub_post_get_content times: 2 do
      process :index, method: :get, params: { project_id: @project }
    end
    posts = assigns :posts
    assert posts, 'expect posts'
    assert posts.any?, 'expect posts'
    
    assert_template :index
    assert_response :success
  end
  
  def test_index_ordered_by_active_votes
    stub_post_get_content times: 2 do
      process :index, method: :get, params: { project_id: @project, sort_field: 'active_votes', sort_order: 'desc' }
    end
    posts = assigns :posts
    assert posts, 'expect posts'
    assert posts.any?, 'expect posts'
    
    assert_template :index
    assert_response :success
  end
  
  def test_index_ordered_by_pending_payout_value
    stub_post_get_content times: 2 do
      process :index, method: :get, params: { project_id: @project, sort_field: 'pending_payout_value', sort_order: 'desc' }
    end
    posts = assigns :posts
    assert posts, 'expect posts'
    assert posts.any?, 'expect posts'
    
    assert_template :index
    assert_response :success
  end
  
  # def test_index_no_project
  #   process :index, method: :get
  #   posts = assigns :posts
  #   assert posts, 'expect posts'
  #   
  #   assert_template :index
  #   assert_response :success
  # end
end
