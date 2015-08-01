class API::V1::APIBaseController < ActionController::Base

	before_action :doorkeeper_authorize!

end