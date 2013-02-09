# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email 'email@factory.com'
    password 'password'
    password_confirmation 'password'

    factory :admin do
      admin true
    end
  end
end
