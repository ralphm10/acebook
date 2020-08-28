def sign_in
  fill_in 'session[email]', with: "david@example.com"
  fill_in 'session[password]', with: "password"
  click_button "Log in"
end
