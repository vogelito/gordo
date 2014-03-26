require 'spec_helper'

describe FoodItem do
  before do
    @food_item = FactoryGirl.create(:food_item)
  end

  subject { @food_item }

  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:picture_url) }
  it { should respond_to(:price) }
  it { should respond_to(:active) }

  it { should be_valid }
  it { should_not be_active }

  describe "with active attribute set to 'true'" do
    before do
      @food_item.save!
      @food_item.toggle!(:active)
    end

    it { should be_active }
  end

  describe "when title is not present" do
    before { @food_item.title = " " }
    it { should_not be_valid }
  end

  describe "when title is too long" do
    before { @food_item.title = "a" * 41 }
    it { should_not be_valid }
  end

  describe "when description is not present" do
    before { @food_item.description = " " }
    it { should_not be_valid }
  end

  describe "when description is too long" do
    before { @food_item.description = "a" * 141 }
    it { should_not be_valid }
  end

  describe "when picture url is not present" do
    before { @food_item.picture_url = nil }
    it { should_not be_valid }
  end

  describe "when price is not present" do
    before { @food_item.price = nil }
    it { should_not be_valid }
  end

  describe "when price format is invalid" do
    it "should be invalid" do
      max = Gordo::Application::MAX_PRICE
      min = Gordo::Application::MIN_PRICE
      prices = [max+0.01, min-0.01, "string", "#{max}.01",
                "0.0.0", -7, -0.01, 0, nil, " ", ((min+max)/2)+0.001]
      prices.each do |invalid_price|
        @food_item.price = invalid_price
        expect(@food_item).not_to be_valid
      end
    end
  end

  describe "when price format is valid" do
    it "should be valid" do
      max = Gordo::Application::MAX_PRICE
      min = Gordo::Application::MIN_PRICE
      prices = [max, max-0.01, min, min+0.01,
                "#{((max+min)/2+0.001).round(2)}", (max+min)/2]
      prices.each do |valid_price|
        @food_item.price = valid_price
        expect(@food_item).to be_valid
      end
    end
  end

  describe "food items view" do
    before { FoodItem.delete_all }
    let!(:older_food_item) do
      FactoryGirl.create(:food_item, created_at: 1.day.ago)
    end
    let!(:newer_food_item) do
      FactoryGirl.create(:food_item, created_at: 1.hour.ago)
    end

    it "should have the food items in the right order" do
      expect(FoodItem.all.to_a).to eq [newer_food_item, older_food_item]
    end
  end
end
