require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Gordo' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    #TODO: remove....
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        35.times { FactoryGirl.create(:order, user: user, address: "Unit 1305") }
        sign_in user
        visit root_path
      end

      after { user.orders.delete_all }

      it "should render the user's feed" do
        user.feed.paginate(page: 1).each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.address)
        end
      end

      it "should have order count and pluralize" do
        expect(page).to have_content('35 orders')
      end

      it { should have_selector('div.pagination') }
    end
  end

  describe "Help page" do
    before { visit help_path }

    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }

    let(:heading)    { 'About' }
    let(:page_title) { 'About' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }

    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

   it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title("Help"))
    click_link "Contact"
    expect(page).to have_title(full_title("Contact"))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title("Sign up"))
    click_link "gordo app"
    expect(page).to have_title(full_title(""))
  end

end
