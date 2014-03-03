require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the content 'Gordo App'" do
      visit '/static_pages/home'
      expect(page).to have_content('Gordo App')
    end

    it "should have the right title" do
      visit '/static_pages/home'
      expect(page).to have_title("Gordo | Home")
    end
  end

  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end

    it "should have the right title" do
      visit '/static_pages/help'
      expect(page).to have_title("Gordo | Help")
    end
  end

  describe "About page" do

    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end

    it "should have the right title" do
      visit '/static_pages/about'
      expect(page).to have_title("Gordo | About Us")
    end
  end

  describe "Contact page" do

    it "should have the content 'Contact'" do
      visit '/static_pages/contact'
      expect(page).to have_content('Contact')
    end

    it "should have the right title" do
      visit '/static_pages/contact'
      expect(page).to have_title("Gordo | Contact")
    end
  end
end