require 'spec_helper'

describe FoodItem do
  before do
    @food_item = FoodItem.new(title: "Pad Thai", description: "Delicious beef pad thai with yummy limes",
                                              picture_url: "http://getgordo.com/pics/pad_thai.jpg", price: 7.99)
  end

  subject { @food_item }

  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:picture_url) }
  it { should respond_to(:price) }

  it { should be_valid }

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
                "0.0.0", -7, -0.01, 0, nil, " "]
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
                "6.6", (max+min)/2]
      prices.each do |valid_price|
        @food_item.price = valid_price
        expect(@food_item).to be_valid
      end
    end
  end
end
