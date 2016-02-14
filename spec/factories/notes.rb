FactoryGirl.define do
  factory :note do
    fab_id 1
    body "MyText"
    forward false
    achievement false
  end
end
