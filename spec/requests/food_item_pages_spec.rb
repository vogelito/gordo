require 'spec_helper'

describe "FoodItemPages" do

  subject { page }

  describe "index" do

    let(:admin) { FactoryGirl.create(:admin) }
    let!(:food_item) { FactoryGirl.create(:food_item)}

    before(:each) do
      sign_in admin
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
          expect(page).to have_link('delete', href: food_item_path(food_item))
        end
      end
    end

    describe "delete links" do
      it { should have_link('delete', href: food_item_path(food_item)) }

      it "should be able to delete a food item" do
        expect do
          click_link('delete', match: :first)
        end.to change(FoodItem, :count).by(-1)
      end
    end
  end
end
