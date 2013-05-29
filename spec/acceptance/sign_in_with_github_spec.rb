require 'acceptance/acceptance_helper'

feature 'Sign in with GitHub' do
  let!(:user) { Fabricate(:user, :github_login => Fabricate.sequence(:github_login_sequence)) }
  background do
    Errbit::Config.stub(:github_authentication) { true }
  end

  scenario 'log in via GitHub with recognized user' do
    mock_auth(user.github_login)

    visit '/'
    click_link 'Sign in with GitHub'
    page.should have_content 'Successfully authorized from GitHub account'
  end

  scenario 'reject unrecognized user if authenticating via GitHub' do
    mock_auth('unknown_user')

    visit '/'
    click_link 'Sign in with GitHub'
    page.should have_content 'There are no authorized users with GitHub login'
  end
end
