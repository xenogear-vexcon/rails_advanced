require 'rails_helper'

feature 'User can see all question', %q{ All users can see list of questions } do

  given(:user) {create(:user)}
  given!(:questions) {create_list(:question, 2)}

  background { visit questions_path }

  scenario 'Authenticated user can see list of questions' do
    sign_in(user)
    
    expect(page).to have_content("#{questions[0].title}")
    expect(page).to have_content("#{questions[0].body}")
    expect(page).to have_content("#{questions[1].title}")
    expect(page).to have_content("#{questions[1].body}")
  end


  scenario 'Unauthenticated user can see list of questions' do
    expect(page).to have_content("#{questions[0].title}")
    expect(page).to have_content("#{questions[0].body}")
    expect(page).to have_content("#{questions[1].title}")
    expect(page).to have_content("#{questions[1].body}")
  end
end