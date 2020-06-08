module Ranked
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_object, only: %i[up down]
  end

  def up
    @object.rating_up(current_user)
    set_respond
  end

  def down
    @object.rating_down(current_user)
    set_respond
  end

  private

  def set_object
    @object = controller_name.classify.constantize.find(params[:id])
  end

  def set_respond
    respond_to do |format|
      format.json { render json: @object.rating }
    end
  end

end