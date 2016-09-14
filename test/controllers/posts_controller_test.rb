require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  def setup
    @project = projects(:gi)
    gilligan = users(:gilligan)
    gilligan.projects << @project
    user_sign_in(gilligan)
  end
  
  def test_routings
    assert_routing({ method: 'get', path: 'posts' }, controller: 'posts', action: 'index')
    assert_routing({ method: 'get', path: 'posts/42' }, controller: 'posts', action: 'show', id: '42')
    assert_routing({ method: 'get', path: 'posts/new' }, controller: 'posts', action: 'new')
    assert_routing({ method: 'get', path: 'posts/42/edit' }, controller: 'posts', action: 'edit', id: '42')
    assert_routing({ method: 'get', path: 'posts/42/card' }, controller: 'posts', action: 'card', id: '42')
    assert_routing({ method: 'post', path: 'posts' }, controller: 'posts', action: 'create')
    assert_routing({ method: 'patch', path: 'posts/42' }, controller: 'posts', action: 'update', id: '42')
    assert_routing({ method: 'delete', path: 'posts/42' }, controller: 'posts', action: 'destroy', id: '42')
    assert_routing({ method: 'delete', path: 'posts/42.js' }, controller: 'posts', action: 'destroy', id: '42', format: 'js')
    
    assert_routing({ method: 'get', path: 'projects/99/posts' }, controller: 'posts', action: 'index', project_id: '99')
    assert_routing({ method: 'get', path: 'projects/99/posts/42' }, controller: 'posts', action: 'show', project_id: '99', id: '42')
    assert_routing({ method: 'get', path: 'projects/99/posts/new' }, controller: 'posts', action: 'new', project_id: '99')
    assert_routing({ method: 'get', path: 'projects/99/posts/42/edit' }, controller: 'posts', action: 'edit', project_id: '99', id: '42')
    assert_routing({ method: 'post', path: 'projects/99/posts' }, controller: 'posts', action: 'create', project_id: '99')
    assert_routing({ method: 'patch', path: 'projects/99/posts/42' }, controller: 'posts', action: 'update', project_id: '99', id: '42')
    assert_routing({ method: 'delete', path: 'projects/99/posts/42' }, controller: 'posts', action: 'destroy', project_id: '99', id: '42')
    assert_routing({ method: 'delete', path: 'projects/99/posts/42.js' }, controller: 'posts', action: 'destroy', project_id: '99', id: '42', format: 'js')
  end
  
  def test_index
    process :index, method: :get, params: { project_id: @project }
    posts = assigns :posts
    assert posts, 'expect posts'
    
    assert_template :index
    assert_response :success
  end
  
  def test_index
    process :index, method: :get, params: { project_id: @project, query: 'wikimedia' }
    posts = assigns :posts
    assert posts, 'expect posts'
    
    assert_template :index
    assert_response :success
  end
  
  def test_index_not_signed_in
    user_sign_out
    process :index, method: :get, params: { project_id: @project }
    posts = assigns :posts
    refute posts, 'did not expect posts'
    
    assert_template nil
    assert_redirected_to new_session_url(return_to: "http://test.host/projects/#{@project.to_param}/posts")
  end
  
  # def test_index_no_project
  #   process :index, method: :get
  #   posts = assigns :posts
  #   assert posts, 'expect posts'
  #   
  #   assert_template :index
  #   assert_response :success
  # end
  
  def test_show
    post = posts(:little_buddy)
    
    process :show, method: :get, params: { project_id: post.project, id: post }
    _post = assigns :post
    assert _post, 'expect post'
    
    assert_template :show
    assert_response :success
  end
  
  def test_new
    process :new, method: :get, params: { project_id: @project }
    post = assigns :post
    assert post, 'expect post'
    
    assert_template :new
    assert_response :success
  end
  
  def test_edit
    post = posts(:little_buddy)
    process :edit, method: :get, params: { project_id: post.project, id: post }
    _post = assigns :post
    assert_equal posts(:little_buddy).id, _post.id
    
    assert_template :edit
    assert_response :success
  end
  
  def test_card
    post = posts(:little_buddy)
    stub_post_get_content do
      process :card, method: :get, params: { project_id: post.project, id: post }
    end
    _post = assigns :post
    assert_equal posts(:little_buddy).id, _post.id
    
    assert_template :card
    assert_response :success
  end
  
  def test_create
    params = post_params
    params[:slug] = '@gilligan/a-three-hour-tour'
    stub_post_get_content do
      process :create, method: :post, params: { project_id: post_params[:project_id], post: params }
    end
    post = assigns :post
    assert post.valid?, "expect valid post, got: #{post.errors.inspect}"
    
    assert_template nil
    assert_redirected_to project_post_path(post.project, post)
  end
  
  def test_create_invalid
    params = post_params
    params[:slug] = ''
    process :create, method: :post, params: { project_id: post_params[:project_id], post: params }
    post = assigns :post
    refute post.valid?, 'expect valid post'
    
    assert_template :new
    assert_response :success
  end
  
  def test_create_non_member
    user = User.find_by_nick('gilligan')
    user.memberships.destroy_all
    params = post_params
    params[:slug] = '@gilligan/a-three-hour-tour'
    process :create, method: :post, params: { project_id: post_params[:project_id], post: params }
    post = assigns :post
    assert_nil post, "expect nil post, got: #{post.inspect}"
    
    assert_template nil
    assert_redirected_to dashboard_path(return_to: "http://test.host/projects/#{@project.to_param}/posts")
  end
  
  # def test_create_no_project
  #   params.delete(:project_id)
  #   
  #   process :create, method: :post, params: { post: post_params }
  #   post = assigns :post
  #   refute post.valid?, 'did not expect valid post'
  #   
  #   assert_template :new
  #   assert_response :success
  # end
  
  def test_update
    post = posts(:little_buddy)
    
    process :update, method: :patch, params: { id: post.id, post: post_params }
    _post = assigns :post
    assert _post.valid?, "expect valid post, got: #{_post.errors.inspect}"
    
    assert_template nil
    assert_redirected_to project_post_path(_post.project, _post)
  end
  
  def test_update_invalid
    post = posts(:little_buddy)
    
    process :update, method: :patch, params: { id: post.id, post: post_params.merge(slug: '') }
    _post = assigns :post
    refute _post.valid?, 'expect invalid post'
    
    assert_template :edit
    assert_response :success
  end
  
  def test_update_published
    post = posts(:little_buddy)
    
    assert_no_difference -> { Post.published.count } do
      process :update, method: :patch, params: { id: post.id, post: post_params.merge(published: true) }
    end
    _post = assigns :post
    assert _post.valid?, "expect valid post, got: #{_post.errors.inspect}"
    
    assert_template nil
    assert_redirected_to project_post_path(_post.project, _post)
  end
  
  def test_update_unpublished
    post = posts(:little_buddy)
    
    assert_difference -> { Post.published.count }, -1 do
      process :update, method: :patch, params: { id: post.id, post: post_params.merge(published: 'false') }
    end
    _post = assigns :post
    assert _post.valid?, "expect valid post, got: #{_post.errors.inspect}"
    
    assert_template nil
    assert_redirected_to project_post_path(_post.project, _post)
  end
  
  def test_update_published_not_accepted
    stub_post_get_content do
      @project.posts.create(
        slug: '@gilligan/just-sit-right-back',
        published: true,
        editing_user: users(:mrhowell)
      ).update_columns({
        # Simulated fields
        steem_id: "2.8.413183",
        steem_author: "gilligan",
        steem_permlink: "just-sit-right-back",
        steem_url: "/blog/@gilligain/just-sit-right-back"
      })
    end
    
    post = posts(:little_buddy)
    
    process :update, method: :patch, params: {
      id: post.id, post: post_params.merge(published: true)
    }
    _post = assigns :post
    refute _post.valid?, 'did not expect valid post'
    
    assert_template :edit
    assert_response :success
  end
  
  # def test_update_no_project
  #   post = posts(:little_buddy)
  #   post.project.create(
  #     post: post,
  #   )
  #   params.delete(:project_id)
  #   
  #   process :update, method: :patch, params: { id: post.id, post: post_params }
  #   _post = assigns :post
  #   assert _post.valid?, "expect valid post, got: #{_post.errors.inspect}"
  #   
  #   assert_template nil
  #   assert_redirected_to project_post_path(_post.project, _post)
  # end
  
  def test_destroy
    post = posts(:little_buddy)
    process :destroy, method: :delete, params: { project_id: post.project, id: post }
    _post = assigns :post
    refute _post.persisted?, 'did not expect persisted post'
    
    assert_template nil
    assert_redirected_to project_posts_path(_post.project)
  end
private
  def post_params
    {
      slug: '@gilligan/little-buddy',
      project_id: @project,
      published: false
    }
  end
end
