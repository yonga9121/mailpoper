class RegistrationWorker
  include Sidekiq::Worker

  def perform()
    User.pending_info_emails.each do |user| 
      user.register_in_aweaber
      user.update( email_sent: true)
    end 
  end

end
