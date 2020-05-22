FactoryBot.define do
  factory :reward do
    question
    title { "Best answer" }

    factory :user_reward do
      question
      user
      title { "Best answer received #{user}" }
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/more.jpg'), 'image/jpeg') }
    end
  end
end
