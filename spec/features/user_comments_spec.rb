require 'rails_helper'

RSpec.feature 'comments', type: :feature do
  before 'sign up, login, make post, comment on post' do
    create_user
    user_login
    create_post
    create_comment
  end

  scenario 'Can comment on a post' do
    create_comment
    expect(page).to have_content('This is a comment')
    expect(page).to have_content('Comment Added')
  end

  scenario 'Can amend a comment' do
    fill_in 'update_comment', with: 'This is an updated comment'
    click_button 'Update Comment'
    expect(page).to have_content('This is an updated comment')
    expect(page).to have_content('Comment Updated')
  end

  scenario 'Can delete a comment' do
    click_link 'Delete Comment'
    expect(page).to_not have_content('This is a comment')
    expect(page).to have_content('Comment Deleted')
  end
end
