def create_user
  fill_in 'user[first_name]', with: "Dave"
  fill_in 'user[email]', with: "david@example.com"
  fill_in 'user[password]', with: "password"
  fill_in 'user[password_confirmation]', with: "password"
  click_button "Create User"
end 
