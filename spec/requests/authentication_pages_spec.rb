require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
    it { should_not have_link('Profile') }
    it { should_not have_link('Settings') }
  end

  describe "signin" do

    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_error_message('Invalid') }
      it { should_not have_link('Profile') }
      it { should_not have_link('Settings') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_error_message('Invalid') }
        it { should_not have_link('Profile') }
        it { should_not have_link('Settings') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }

      it { should have_title(user.name) }
      it { should_not have_link('Users',   href: users_path) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      it { should_not have_link('List Food Items',  href: food_items_path) }
      it { should_not have_link('Add Food Item',    href: new_food_item_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end

    describe "with admin information" do
      let(:admin) { FactoryGirl.create(:admin) }
      before { valid_signin(admin) }

      it { should have_link('Users',       href: users_path) }
      it { should have_link('List Food Items',  href: food_items_path) }
      it { should have_link('Add Food Item',    href: new_food_item_path) }

      describe "visiting the users index" do
        before { visit users_path }
        it { should have_title('All users') }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end

          describe "when signing in again" do
            before do
              click_link "Sign out"
              visit signin_path
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"
            end

            it "should render the default (profile) page" do
              expect(page).to have_title(user.name)
            end
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end
      end

      describe "in the Orders controller" do

        describe "submitting to the create action" do
          before { post orders_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete order_path(FactoryGirl.create(:order)) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end

      describe "in the FoodItems controller" do

        describe "visitng the food item index" do
          before { visit food_items_path }
          it { should have_title('Sign in') }
        end

          describe "submitting to the create action" do
            before { post food_items_path }
            specify { expect(response).to redirect_to(signin_path) }
          end
      end

    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com", cellphone: get_random_phone) } 
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as normal user" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user, no_capybara: true }

      describe "submitting a POST request to the Users#create action" do
        let(:new_user) { FactoryGirl.create(:user) }
        before {  post users_path user: new_user.attributes }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a GET request to the Users#new action" do
        before { get new_user_path }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a GET request to the Users#index action" do
        before { get users_path }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a GET request to the FoodItems#index action" do
        before { get food_items_path }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a DELETE request to the FoodItems#destroy action" do
        before { delete food_item_path(FactoryGirl.create(:food_item)) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a POST request to the FoodItems#create action" do
        before { post food_items_path(FactoryGirl.create(:food_item)) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as admin user" do
      let(:admin) { FactoryGirl.create(:admin) }

      before { sign_in admin, no_capybara: true}

      describe "submitting a DELETE request to the Users#destroy action for itself" do
        specify { expect { delete user_path(admin) }.not_to change(User, :count) }
      end

      describe "submitting a POST request to the FoodItems#create action" do
        let(:food_item) { FactoryGirl.create(:food_item) }
        specify { expect{ post food_items_path food_item: food_item.attributes }.to change(FoodItem, :count) }
      end
    end
  end
end