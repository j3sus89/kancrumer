class User
  include Mongoid::Document
  include Mongoid::Paperclip

  has_mongoid_attached_file :avatar, styles: { medium: '250x250>', thumb: '38x38>' }, default_url: "/system/users/avatars/default.jpg"
  field :name, type: String
  field :role, type: String
  field :email, type: String
  field :crypted_password, type: String
  field :salt, type: String

  field :activation_state,            type: String
  field :activation_token,            type: String
  index({ activation_token: 1 }, { unique: true, background: true })

  field :reset_password_token,            type: String, default: nil
  field :reset_password_token_expires_at, type: DateTime, default: nil
  field :reset_password_email_sent_at,    type: DateTime, default: nil

  has_and_belongs_to_many :projects

  authenticates_with_sorcery!

  validates_presence_of :name
  validates :password, length: { minimum: 6 }, presence: true, confirmation: true, :on => :create
  validates :email, uniqueness: true, presence: true


  def isScrumMasterOrProductOwner?
    aux = false
    Project.all.each do |p|
      if p.isScrumMasterOrProductOwner?(self)
        aux = true
      end
    end
    return aux
  end

  def isAdmin?
    if self.role == "admin"
      return true
    else
      return false
    end
  end

  def deleteUserFromUserStories
    self.projects.each do |p|
      p.deleteFromUserStories(self._id)
      p.save
    end
  end

  def deleteUserFromComments
    self.projects.each do |p|
      p.deleteFromComments(self._id)
      p.save
    end
  end

end#okkko
