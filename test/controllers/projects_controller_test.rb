require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  def setup
    @project = projects(:gi)
    gilligan = users(:gilligan)
    gilligan.projects << @project
    user_sign_in(gilligan)
  end
  
  def test_routings
    assert_routing({ method: 'get', path: 'projects' }, controller: 'projects', action: 'index')
    assert_routing({ method: 'get', path: 'projects/42' }, controller: 'projects', action: 'show', id: '42')
    assert_routing({ method: 'get', path: 'projects/new' }, controller: 'projects', action: 'new')
    assert_routing({ method: 'get', path: 'projects/42/edit' }, controller: 'projects', action: 'edit', id: '42')
    assert_routing({ method: 'get', path: 'projects/42/card' }, controller: 'projects', action: 'card', id: '42')
    assert_routing({ method: 'post', path: 'projects' }, controller: 'projects', action: 'create')
    assert_routing({ method: 'patch', path: 'projects/42' }, controller: 'projects', action: 'update', id: '42')
    assert_routing({ method: 'delete', path: 'projects/42' }, controller: 'projects', action: 'destroy', id: '42')
    assert_routing({ method: 'delete', path: 'projects/42.js' }, controller: 'projects', action: 'destroy', id: '42', format: 'js')
  end
  
  def test_index
    process :index, method: :get
    projects = assigns :projects
    assert projects, 'expect project'
    
    assert_template :index
    assert_response :success
  end
  
  def test_show
    process :show, method: :get, params: { id: @project }
    project = assigns :project
    assert project, 'expect project'
    
    assert_template :show
    assert_response :success
  end
  
  def test_new
    process :new, method: :get
    project = assigns :project
    assert project, 'expect project'
    
    assert_template :new
    assert_response :success
  end
  
  def test_edit
    process :edit, method: :get, params: { id: @project }
    project = assigns :project
    assert_equal @project, project
    
    assert_template :edit
    assert_response :success
  end
  
  def test_card
    process :card, method: :get, params: { id: @project }
    project = assigns :project
    assert_equal @project, project
    
    assert_template :card
    assert_response :success
  end
  
  def test_create
    process :create, method: :post, params: { project: project_params }
    project = assigns :project
    assert project.valid?, "expect valid project, got: #{project.errors.inspect}"
    
    assert_template nil
    assert_redirected_to projects_path
  end
  
  def test_create_invalid
    process :create, method: :post, params: { project: project_params.merge(code: '') }
    project = assigns :project
    refute project.valid?, 'expect invalid project'
    
    assert_template :new
    assert_response :success
  end
  
  def test_update
    process :update, method: :patch, params: { id: @project, project: project_params }
    project = assigns :project
    assert project.valid?, "expect valid project, got: #{project.errors.inspect}"
    
    assert_template nil
    assert_redirected_to projects_path
  end
  
  def test_update_invalid
    process :update, method: :patch, params: { id: @project, project: project_params.merge(code: '') }
    project = assigns :project
    refute project.valid?, 'expect invalid project'
    
    assert_template :edit
    assert_response :success
  end
  
  def test_destroy
    @project.posts.destroy_all # to avoid dependent error
    
    process :destroy, method: :delete, params: { id: @project }
    project = assigns :project
    refute project.persisted?, "did not expect persisted project: #{project.errors.inspect}"
    
    assert_template nil
    assert_redirected_to projects_path
  end
  
  def test_destroy_dependent_error
    process :destroy, method: :delete, params: { id: @project }
    project = assigns :project
    assert project.persisted?, 'expect persisted project due to dependent: :restrict_with_error'
    
    assert_template nil
    assert_redirected_to projects_path
  end
private
  def project_params
    {
      name: 'Name',
      code: 'code',
    }
  end
end
