require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'empty update should not happen' do
    users(:one).name = ' '
    assert_not users(:one).save
  end
end
