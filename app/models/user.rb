class User
  include Mongoid::Document
  include Mongoid::Timestamps


  field :email
  field :phone
  field :name
  field :send_info, default: false, type: Boolean
  field :email_sent, default: false, type: Boolean

  validate :email_validation
  validate :phone_validation
  validate :unique_email_and_phone

  def unique_email_and_phone
    if !self.persisted? || (self.persisted? && self.email_changed? || self.phone_changed?)
      aux = self.class.any_of({email: self.email}, {phone: self.phone}).first
      raise Errors::User::EmailOrPhoneAlreadyTaken if aux
    end 
  end 

  def email_validation
    if self.email.blank? || (!self.email.blank? && self.email.scan(URI::MailTo::EMAIL_REGEXP).empty?)
      raise Errors::User::EmailNotValid 
    end
  end 

  def phone_validation
    if self.phone.blank? || (!self.phone.blank? && (!self.phone.numeric? || self.phone.to_s.size < 10) )
      raise Errors::User::PhoneNotValid 
    end
  end 

  def self.pending_info_emails
    where(
      send_info: true,
      email_sent: false
    )
  end
  
  def register_in_aweaber()
    acc = AweaberAccount.last
    acc.add_subscriber(self)
  end 
  
end
