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

  describe "when description is not present" do
    before { @food_item.description = " " }
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

end
