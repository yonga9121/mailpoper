class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email
  field :phone
  field :name
  field :send_info, default: false

end
