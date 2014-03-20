require 'spec_helper'

describe "Order pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "order creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create an order" do
        expect { click_button "Post" }.not_to change(Order, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'order_address', with: "1 Western Ave" }
      it "should create an order" do
        expect { click_button "Post" }.to change(Order, :count).by(1)
      end
    end
  end

  #TODO: this shouldn't be allowed
  describe "order destruction" do
    before { FactoryGirl.create(:order, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a order" do
        expect { click_link "delete" }.to change(Order, :count).by(-1)
      end
    end
  end
end