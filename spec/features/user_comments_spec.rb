require 'rails_helper'

RSpec.feature 'comments', type: :feature do

  before 'sign up, login and make post' do
    create_user
    user_login
    create_post
  end

  scenario 'Can comment on a post' do
    fill_in 'add_comment', with: 'This is a comment'
    click_button 'New comment'
    expect(page).to have_content('This is a comment')
  end

end
