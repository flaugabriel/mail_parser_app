class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def render_turbo_flash
    turbo_stream.update("flash-messages", partial: "layouts/flash")
  end
end
