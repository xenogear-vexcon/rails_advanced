require 'rails_helper'

feature 'User can able to see own rewards' do

  given(:users) {create_list(:user, 2)}
  given(:question) {create(:question, user: users.first)}
  given!(:reward) {create(:user_reward, question: question, user: users.second)}

  scenario 'User can see list of own rewards', js: true do
    sign_in(users.second)
    visit(user_rewards_path(users.second))

    expect(page).to have_content("#{reward.title}")
    expect(page).to have_xpath("//img[contains(@src,'more.jpg')]")
    expect(page).to have_content("#{question.title}")
  end
end