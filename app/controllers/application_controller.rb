class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :set_locale

  def set_locale
    I18n.locale = current_user&.language || I18n.default_locale
  end
end
