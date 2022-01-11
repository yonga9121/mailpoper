class UsersController < ApplicationController

    before_action :current_account

    def create
        user = User.new user_params
        user.validate
        user.create!
        render :json, { success: user.send_info ? I18n.t("registration_success_poping") : I18n.t("registration_success_not_poping") }
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
