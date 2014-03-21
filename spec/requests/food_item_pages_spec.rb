require 'spec_helper'

describe "FoodItemPages" do

  subject { page }

  describe "index" do

    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in user
      visit food_items_path
    end

    it { should have_title('Food Items') }
    it { should have_content('Food Items') }

    describe "pagination" do

      before(:all) { 31.times { FactoryGirl.create(:food_item) } }
      after(:all)  { FoodItem.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each food item" do
        FoodItem.paginate(page: 1).each do |food_item|
          expect(page).to have_selector('li', text: food_item.title)
        end
      end
    end
  end
end
