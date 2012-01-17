module HelperMethods
  def sign_in(user)
    visit new_user_session_path
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "testing123"
    click_button "Sign in"
    page.should_not have_content("Invalid email or password.")
  end

  def accept_alert
    page.driver.browser.switch_to.alert.accept
    sleep 0.1
  end
end

RSpec.configuration.include HelperMethods, :type => :request

