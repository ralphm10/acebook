require 'rails_helper'

RSpec.feature 'Sign Up', type: :feature do
  scenario 'Can sign up as a new user' do
    visit '/users/new'
    create_user
    expect(page).to have_content('Acebook Logged in as: test')
  end

  scenario 'Invalid email address' do
    visit '/users/new'
    fill_in('first_name', with: 'test')
    fill_in('last_name', with: 'test_last_name')
    fill_in('email', with: 'testtest.com')
    fill_in('password', with: '123123')
    fill_in('password_confirmation', with: '123123')
    click_button('Create User')
    expect(page).to have_content('Invalid email address')
  end

  scenario 'Password too short' do
    visit '/users/new'
    fill_in('first_name', with: 'test')
    fill_in('last_name', with: 'test_last_name')
    fill_in('email', with: 'test@test.com')
    fill_in('password', with: '12312')
    fill_in('password_confirmation', with: '12312')
    click_button('Create User')
    expect(page).to have_content('Password must be between 6 and 10 characters')
  end

  scenario 'Password too long' do
    visit '/users/new'
    fill_in('first_name', with: 'test')
    fill_in('last_name', with: 'test_last_name')
    fill_in('email', with: 'test@test.com')
    fill_in('password', with: '123123123123')
    fill_in('password_confirmation', with: '123123123123')
    click_button('Create User')
    expect(page).to have_content('Password must be between 6 and 10 characters')
  end

  scenario 'No first name' do
    visit '/users/new'
    fill_in('last_name', with: 'test_last_name')
    fill_in('email', with: 'test@test.com')
    fill_in('password', with: '123123')
    fill_in('password_confirmation', with: '123123')
    click_button('Create User')
    expect(page).to have_content('First name is a required field')
  end

  scenario 'Passwords do not match' do
    visit '/users/new'
    fill_in('first_name', with: 'test')
    fill_in('last_name', with: 'test_last_name')
    fill_in('email', with: 'test@test.com')
    fill_in('password', with: '123123')
    fill_in('password_confirmation', with: '123321')
    click_button('Create User')
    expect(page).to have_content('Passwords do not match')
  end
end
