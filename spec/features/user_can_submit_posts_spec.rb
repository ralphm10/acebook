require 'rails_helper'
require 'create_user'
require 'sign_in'

RSpec.feature "Timeline", type: :feature do
  scenario "Can submit posts and view them" do
    visit "/posts"
    create_user
    sign_in
    click_link "New post"
    fill_in "Message", with: "Hello, world!"
    click_button "Submit"
    expect(page).to have_content("Hello, world!")
  end

  scenario "Show the newest post first" do
    visit "/posts"
    create_user
    sign_in
    click_link "New post"
    fill_in "Message", with: "Hello, world!"
    click_button "Submit"
    click_link "New post"
    fill_in "Message", with: "Hello, acebook-team2!"
    click_button "Submit"
    expect(Post.order(created_at: :desc)[0].message).to eq("Hello, acebook-team2!")
  end

end
