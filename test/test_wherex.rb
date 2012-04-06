require 'helper'

class TestWherex < Test::Unit::TestCase
  def test_user_example
    assert u = User.where( :zipcode => /^9[345][0-9]{3}$/ )
    assert_equal 3, u.count
    [:two, :three, :four ].each do |id|
      assert u.include?( users(id) )
    end
  end

  def test_product_example
    assert p = Product.find_by_code( /^[NRW][^-]+-[456]/ )
    assert_equal products(:one), p

    assert p = Product.find_all_by_code( /^[NRW][^-]+-[456]/ )
    assert_equal 1, p.count
    assert_equal products(:one), p.first
  end

  def test_student_example
    assert s = Student.all( :conditions => { :name => /[^a-zA-Z ]/ } )
    assert_equal 3, s.count
    [ :two, :three, :four ].each do |id|
      assert s.include?( students(id) )
    end
  end
end
