require 'rails_helper'

RSpec.feature "Redirects", type: :feature do
  scenario "user is taken to sign up page if not looged in" do
    visit "/posts"
    expect(page).to have_button('Create User')
  end
end 
