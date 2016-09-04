require "test_helper"

class PostTest < ActiveSupport::TestCase
  def post
    stub_post_get_content
    post_params = {
      slug: '@maryann/girl-next-door',
      project: projects(:rhw),
      editing_user: users(:gilligan)
    }
    @post ||= Post.new(post_params)
  end
  
  def test_valid
    assert post.valid?, "expect valid post, got: #{post.errors.inspect}"
    assert post.submitted?
    refute post.accepted?
    refute post.rejected?
    refute post.passed?
    assert post.content!
  end
  
  def test_status
    assert Post.status :accepted
    assert Post.status :accepted, false
  end
end
