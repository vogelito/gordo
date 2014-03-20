require 'spec_helper'

describe Order do

  let(:user) { FactoryGirl.create(:user) }
  before { @order = user.orders.build(address: "1 Western Ave Unit 1305") }

  subject { @order }

  it { should respond_to(:address) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @order.user_id = nil }
    it { should_not be_valid }
  end
end
