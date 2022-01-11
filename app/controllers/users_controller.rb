class UsersController < ApplicationController

    before_action :current_account

    def create
        user = User.new user_params
        user.save!
        render :json, { mssg: "Success. Thx for using mailpoper app." }
    end

    def welcome
        render json: {mssg: "Welcome to mailpoper app"}
    end

    private 

    def user_params
        params.require(:user).permit(
            :email, :name, :phone, :send_info
        )
    end 


end
