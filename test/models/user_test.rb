require "test_helper"

class UserTest < ActiveSupport::TestCase
  def user
    user_params = {
      email: 'test@test.com',
      nick: 'nick',
      password: 'password',
      password_confirmation: 'password'
    }
    @user ||= User.new(user_params)
  end
  
  def test_valid
    assert user.valid?, "expect valid user, got: #{user.errors.inspect}"
  end
  
  def test_authenticate
    user = users(:gilligan)
    assert_equal user, User.authenticate(user.email, 'password')
  end
end
