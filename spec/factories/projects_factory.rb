# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project1, class: Project do
    name 'Project 1'
    scrumMaster '52a779444a657303b9010000'
    productOwner '52a89ca04a657301e5010000'
    description 'text here'
  end

  factory :project2, class: Project do
    name 'Project 2'
    scrumMaster '52a89ca04a657301e5010000'
    productOwner '52a779444a657303b9010000'
    description 'text here'
  end

  factory :project_with, class: Project do
    name 'Project 3'
    scrumMaster '52a779444a657303b9010000'
    productOwner '52a89ca04a657301e5010000'
    description 'text here'
    users {}
    sprints {}
  end

end
