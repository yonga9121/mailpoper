class RegistrationWorker
  include Sidekiq::Worker

  def perform()
    User.pending_emails.each do |user| 
      user.register_in_aweaber
    end 
  end

end
