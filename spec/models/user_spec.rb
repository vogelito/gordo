require 'spec_helper'

describe User do
  before do
    @user = User.new(name: "Example User", email: "user@example.com", cellphone: "1234567890", 
                                default_address: "1 Western Ave Unit 1305", password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:cellphone) }
  it { should respond_to(:default_address) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:orders) }
  #TODO: remove....
  it { should respond_to(:feed) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com ]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.cellphone = "1234567891"
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when cellphone is not present" do
    before { @user.cellphone = " " }
    it { should_not be_valid }
  end

  describe "when cellphone is already taken" do
    before do
      user_with_same_cellphone = @user.dup
      user_with_same_cellphone.email = "other@other.com"
      user_with_same_cellphone.save
    end

    it { should_not be_valid }
  end

  describe "when cellphone format is invalid" do
    it "should be invalid" do
      cellphones = ["+1 (222) 333-4444 5", "+44 (222) 333-4444",
                    "string"]
      cellphones.each do |invalid_cellphone|
        @user.cellphone = invalid_cellphone
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when cellphone format is valid" do
    it "should be valid" do
      cellphones = ["+1 (222) 333-4444", "+1 (222) 333 4444",
                    "+1 (222) 3334444", "+1 (222)3334444",
                    "+1(222)3334444", "+12223334444", "12223334444",
                    "2223334444", "222 333 4444", "222-333-4444",
                    "+1 remove (222) random 333-4444 strings"]
      cellphones.each do |valid_cellphone|
        @user.cellphone = valid_cellphone
        expect(@user).to be_valid
      end
    end
  end

  describe "when default address is not present" do
    before { @user.default_address = " " }
    it { should_not be_valid }
  end

  describe "when default address is too long" do
    before { @user.default_address = "a" * 101 }
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before do
      @user.password = " "
      @user.password_confirmation = " "
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "order associations" do

    before { @user.save }
    let!(:older_order) do
      FactoryGirl.create(:order, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_order) do
      FactoryGirl.create(:order, user: @user, created_at: 1.hour.ago)
    end

    it "should have the orders arranged by descending time (newest orders first)" do
      expect(@user.orders.to_a).to eq [newer_order, older_order]
    end

    it "should destroy associated orders" do
      orders = @user.orders.to_a
      @user.destroy
      expect(orders).not_to be_empty
      orders.each do |order|
        expect(Order.where(id: order.id)).to be_empty
      end
    end

    #TODO: remove....
    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:order, user: FactoryGirl.create(:user))
      end

      its(:feed) { should include(newer_order) }
      its(:feed) { should include(older_order) }
      its(:feed) { should_not include(unfollowed_post) }
    end
  end
end