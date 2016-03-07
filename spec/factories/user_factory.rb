require 'factory_girl'

FactoryGirl.define do
  factory :usuario, class: User do
    name 'John User'
    email 'useur@user.com'
    role 'user'
    password '123456'
    password_confirmation '123456'
    projects {}
  end

  factory :usuario2, class: User do
    name 'Jim User'
    email 'user2@user.com'
    role 'user'
    password '123456'
    password_confirmation '123456'
  end

    factory :usuario3, class: User do
    name 'Jean Duser'
    email 'user@uesr.com'
    role 'user'
    password '123456'
    password_confirmation '123456'
  end

  factory :administrador, class: User do
  	name 'Joe Admin'
    email 'admiun@admin.com'
    role 'admin'
    password '123456'
    password_confirmation '123456'
  end

    factory :administrador2, class: User do
    name 'Jack Admin'
    email 'admin2@admin.com'
    role 'admin'
    password '123456'
    password_confirmation '123456'
  end
end