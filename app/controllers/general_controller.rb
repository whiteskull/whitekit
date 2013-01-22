class GeneralController < ApplicationController
  def index
  end

  # POST /make_aliases
  def make_aliases
    if current_user.try(:admin?)
      Page.make_aliases
    end

    respond_to do |format|
      format.js
    end
  end
end
