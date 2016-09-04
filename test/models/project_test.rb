require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  def project
    project_params = {
      name: 'Sandbox',
      code: 'sandbox'
    }
    @project ||= Project.new(project_params)
  end
  
  def test_valid
    assert project.valid?, "expect valid project, got: #{project.errors.inspect}"
  end
end
