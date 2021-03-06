require 'spec_helper'

describe User do
  it { should validate_presence_of(:name) }
  it { should have_many(:memberships) }
  it { should have_many(:organizations).through(:memberships) }
  it { should have_many(:api_keys) }

  it "#session_api_key" do
    user = FactoryGirl.create(:user)
    api_key = user.session_api_key
    assert !api_key.new_record?
    assert api_key.access_token =~ /\S{32}/
  end

  it "should validate password if is_activated is true" do
    user = User.new(is_activated: true)
    user.valid?
    user.errors.messages.keys.should include :password
  end

  it "should NOT validate password if is_activated is false" do
    user = User.new
    user.valid?
    user.errors.messages.keys.should_not include :password
  end

  it "#clear_expired_api_keys" do
    user = FactoryGirl.create(:user)
    3.times do
      api_key = user.session_api_key
      api_key.update_attribute(:expired_at, 10.days.ago)
    end
    user.session_api_key
    user.api_keys.size.should == 4
    user.clear_expired_api_keys
    user.api_keys.size.should == 1
  end

  it "#can_manage?(organization)" do
    user = FactoryGirl.create(:user)
    organization = FactoryGirl.create(:organization)
    membership = user.memberships.create!(is_admin: true, organization: organization)
    user.can_manage?(organization).should be_true

    membership.update_attribute(:is_admin, false)
    user.can_manage?(organization).should be_false
  end
end
