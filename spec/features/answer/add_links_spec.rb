require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) {create(:question, user: user)}
  given(:image_url) { 'https://badges-2019.s3.eu-west-3.amazonaws.com/loxmhpru0kfl84uhcfzljhvvqrcn' }

  scenario 'User adds link when create an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My image'
    fill_in 'Url', with: image_url

    click_on 'Answer'

    expect(page).to have_link 'My image', href: image_url
  end

end