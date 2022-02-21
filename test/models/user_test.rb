require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'empty update should not happen' do
    users(:one).name = ' '
    users(:one).email = ' '
    assert_not users(:one).save
  end

  test 'duplicate email' do
    user = User.new
    user.email = 'abcd@gmail.com'
    user.password_digest = BCrypt::Password.create('secret')
    user.name = 'Rachit'
    assert_not user.save
  end

  test 'destroy user' do
    assert users(:one).delete
  end

  test 'empty field user' do
    user = User.new
    user.email = ' '
    user.password_digest = BCrypt::Password.create('secret')
    user.name = ' '
    assert_not user.save
  end

  test 'invalid email' do
    user = User.new
    user.email = 'abcdgmailcom'
    user.password_digest = BCrypt::Password.create('secret')
    user.name = 'Rachit'
    assert_not user.save
  end
end
