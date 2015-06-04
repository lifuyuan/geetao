class UserManageController < ApplicationController
	before_filter :authenticate_user!

	def edit_avatar
		@user = current_user
	end

	def update_avatar
		@user = current_user
		@user.update_attributes(params[:user].permit(:avatar))
		redirect_to root_path
	end

end
