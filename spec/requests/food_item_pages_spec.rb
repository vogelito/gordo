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
          expect(page).not_to have_link('Deactivate')
          expect(page).to have_link('Activate')
        end
      end
    end

    describe "when activating a food item" do
      before do
        FoodItem.first.toggle!(:active)
        visit food_items_path
      end

      it "should have a Deactivate link" do
        expect(page).to have_link('Deactivate')
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

  describe "add" do

    let(:admin) { FactoryGirl.create(:admin) }

    before(:each) do
      sign_in admin
      visit new_food_item_path
    end

    let(:submit) { "Add Food Item" }

    describe "with invalid information" do
      it "should not create a food item" do
        expect { click_button submit }.not_to change(FoodItem, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Add Food Item') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Title",          with: "Beef Pad Thai"
        fill_in "Description",    with: "Delicious Beef Pad Thai with a hint of lime"
        fill_in "Picture Url",     with: "http://getgordo.com/pics/pad_thai.jpg"
        fill_in "Price", with: "7.99"
      end

      describe "after saving the food item" do
        before { click_button submit }
        let(:food_item) { FoodItem.last }

        it { should have_title("Food Items") }
        it { should have_selector('li', text: food_item.title) }
        it { should have_selector('div.alert.alert-success', text: "Food Item \"#{food_item.title}\" added") }
      end
    end
  end
end
