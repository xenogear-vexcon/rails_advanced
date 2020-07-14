require 'rails_helper'

feature 'It can a comments be added. ' do
  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users.first) }
  given!(:question2) { create(:question, user: users.first) }
  given!(:answer) { create(:answer, question: question, user: users.second) }
  given!(:answer2) { create(:answer, question: question, user: users.second) }
  given!(:answer3) { create(:answer, question: question2, user: users.second) }

  describe 'Authenticated user ', js: true do

    background do
      Capybara.using_session('user') do
        sign_in(users.first)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('guest2') do
        visit question_path(question2)
      end
    end

    scenario 'can comment question and everyone can see it only under that question' do

      Capybara.using_session('user') do
        within ".question_#{question.id}" do
          within '.new-comment' do
            fill_in :comment_body, with: 'New comment for question'
            click_on 'comment'
          end
        end
        within ".question_#{question.id}_comments" do
          expect(page).to have_content 'New comment for question'
        end
        within ".answer_#{answer.id}_comments" do
          expect(page).to_not have_content 'New comment for question'
        end
      end

      Capybara.using_session('guest') do
        within ".question_#{question.id}_comments" do
          expect(page).to have_content 'New comment for question'
        end
        expect(page).to have_css(".answer_#{answer.id}_comments", visible: :hidden)
      end

      Capybara.using_session('guest2') do
        expect(page).to have_css(".question_#{question2.id}_comments", visible: :hidden)
        expect(page).to have_css(".answer_#{answer3.id}_comments", visible: :hidden)
      end
    end

    scenario 'can comment answer and everyone can see it only under that answer' do

      Capybara.using_session('user') do
        within ".answer_#{answer.id}" do
          within '.new-comment' do
            fill_in :comment_body, with: 'New comment for answer'
            click_on 'comment'
          end
        end

        within ".answer_#{answer.id}_comments" do
          expect(page).to have_content 'New comment for answer'
        end

        within ".answer_#{answer2.id}_comments" do
          expect(page).to_not have_content 'New comment for answer'
        end

        within ".question_#{question.id}_comments" do
          expect(page).to_not have_content 'New comment for answer'
        end
      end

      Capybara.using_session('guest') do
        within ".answer_#{answer.id}_comments" do
          expect(page).to have_content 'New comment for answer'
        end
        expect(page).to have_css(".answer_#{answer2.id}_comments", visible: :hidden)
      end

      Capybara.using_session('guest2') do
        expect(page).to have_css(".question_#{question2.id}_comments", visible: :hidden)
        expect(page).to have_css(".answer_#{answer3.id}_comments", visible: :hidden)
      end
    end

    # scenario 'see an error if body will be blank.' do
    #   Capybara.using_session('user') do

    #     within ".question_#{question.id}_comments" do
    #       within '.new-comment' do
    #         fill_in :comment_body, with: ''
    #         click_on 'comment'
    #       end
    #     end

    #     within '.comment-errors' do
    #       expect(page).to have_content "Body can't be blank"
    #     end
    #   end
    # end

  end
end
