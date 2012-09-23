class Spree::UserSessionsController < Devise::SessionsController
  include Spree::Core::ControllerHelpers
  helper 'spree/users', 'spree/base'

  include Spree::Core::CurrentOrder

  after_filter :associate_user, :only => :create

  ssl_required :new, :create, :destroy, :update
  ssl_allowed :login_bar

  # GET /resource/sign_in
  def new
    super
  end

  def create
    authenticate_user!

    if user_signed_in?
      user = current_user
      user.generate_api_key!
      cookies.permanent[:api_key] = user.api_key
      flash.notice = t(:logged_in_succesfully)
      respond_to do |format|
        format.html {
          redirect_back_or_default(products_path)
        }
        format.js {
          render :json => {:message => flash[:notice], :success => true, :email => user.email, :ship_address => user.ship_address }.to_json
          #render :json => {:ship_address => user.ship_address, :bill_address => user.bill_address}.to_json
        }
      end
    else
     flash.now[:error] = t('devise.failure.invalid')
     respond_to do |format|
     	format.html{
     	 render :new
     	 }
     	 format.js{
     	 	render :json => {:message => flash.now[:error], :success => false }.to_json
     	 }
     end
    end
  end

  def destroy
    cookies.clear
    session.clear
    super
  end

  def nav_bar
    render :partial => 'spree/shared/nav_bar'
  end

  private
    def accurate_title
      t(:login)
    end
end
