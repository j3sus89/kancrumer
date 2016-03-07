class UserMailer < ActionMailer::Base
  default :from => "kancrumer@gmail.com"
  #default :from => "kancrumer@admin"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_needed_email.subject
  #
  def activation_needed_email(user)
    @user = user
    #@url = "http://0.0.0.0:3000/users/#{user.activation_token}/activate"
    @url = "http://kancrumer.herokuapp.com/users/#{user.activation_token}/activate"
    mail(:to => user.email, :subject => "Welcome to Kancrumer")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_success_email.subject
  #
  def activation_success_email(user)
    @user = user
    #@url  = "http://0.0.0.0:3000/login"
    @url = "http://kancrumer.herokuapp.com/login"
    mail(:to => user.email, :subject => "Your account is now activated")
  end

  def reset_password_email(user)
    @user = user
    #@url = "http://0.0.0.0:3000/password_resets/#{user.reset_password_token}/edit"
    @url = "http://kancrumer.herokuapp.com/password_resets/#{user.reset_password_token}/edit"
    mail(:to => user.email, :subject => "Your password has been reset")
  end

  def new_project(project)
    @project = project
    #@url = "http://0.0.0.0:3000/projects"
    @url = "http://kancrumer.herokuapp.com/projects"
    mail(:to => @project.getScrumMaster.email, :subject => "New project")
  end

  def new_scrumMaster(project)
    @project = project
    #@url = "http://0.0.0.0:3000/projects"
    @url = "http://kancrumer.herokuapp.com/projects"
    mail(:to => @project.getScrumMaster.email, :subject => "New project as Scrum Master")
  end

  def reject_scrumMaster(user, project)
    @project = project
    @user = user
    mail(:to => @user.email, :subject => "Rejected as Scrum Master")
  end

  def new_productOwner(project)
    @project = project
    #@url = "http://0.0.0.0:3000/projects"
    @url = "http://kancrumer.herokuapp.com/projects"
    mail(:to => @project.getProductOwner.email, :subject => "New project as Product Owner")
  end

  def reject_productOwner(user, project)
    @project = project
    @user = user
    mail(:to => @user.email, :subject => "Rejected as Product Owner")
  end

  def new_scrumMember(user, project)
    @project = project
    @user = user
    #@url = "http://0.0.0.0:3000/projects"
    @url = "http://kancrumer.herokuapp.com/projects"
    mail(:to => @user.email, :subject => "New project as Scrum Member")
  end

  def reject_scrumMember(user, project)
    @project = project
    @user = user
    mail(:to => @user.email, :subject => "Dismissed as Scrum Member")
  end
end
