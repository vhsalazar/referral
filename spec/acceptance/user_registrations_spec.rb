require 'rails_helper'

RSpec.feature "UserRegistrations", type: :feature do
  scenario "User visits the registration page" do
    visit new_registration_path
    expect(page).to have_selector('h1', text: 'Sign up')
    expect(page).to have_selector("form#new_user")
  end

  scenario "User registers with valid details" do
    visit new_registration_path
    fill_in "user[email_address]", with: "test@example.com"
    fill_in "user[password]", with: "password"
    fill_in "user[password_confirmation]", with: "password"
    click_button "Sign up"

    expect(page).to have_content("Successfully signed up!")

    expect(User.first).not_to be_nil
  end

  context "User registers with invalid details" do
    before do
      visit new_registration_path
    end

    after do
      expect(User.any?).to be_falsey
    end

    scenario "when email address is invalid" do
      fill_in "user[email_address]", with: "invalid"
      click_button "Sign up"
      expect(page).to have_content("Email address is invalid")
      expect(page).to have_content("There was a problem with your registration.")
    end

    scenario "when referer code is invalid" do
      fill_in "user[email_address]", with: "somebody@gmail.com"
      fill_in "user[referer_code]", with: "QWERTY"
      click_button "Sign up"
      expect(page).to have_content("Referer code is invalid")
      expect(page).to have_content("There was a problem with your registration.")
    end

    scenario "when password is blank" do
      fill_in "user[email_address]", with: "somebody@gmail.com"
      click_button "Sign up"
      expect(page).to have_content("Password can't be blank")
    end

    scenario "when password and password confirmation do not match" do
      fill_in "user[email_address]", with: "somebody@gmail.com"
      fill_in "user[password]", with: "password"
      fill_in "user[password_confirmation]", with: "password123"
      click_button "Sign up"
      expect(page).to have_content("Password confirmation doesn't match Password")
    end

    scenario "when referer code does not exist" do
      visit new_registration_path(referer_code: "ABC123")
      click_button "Sign up"
      expect(page).to have_content("Referer code is invalid")
    end
  end

  context "when referer code is passed as a query string" do
    scenario "it populates the referer code field" do
      visit new_registration_path(referer_code: "ABC123")
      expect(find_field('user[referer_code]').value).to eq "ABC123"
    end
  end
end
