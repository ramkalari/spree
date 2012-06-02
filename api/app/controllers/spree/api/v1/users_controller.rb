module Spree
	module Api
		module V1
			class UsersController < Spree::Api::V1::BaseController
				
				def get_last_completed_order
					last_completed_order = current_api_user.orders.complete.order("id desc").first
					render :show
				end
			end
		end
	end
end