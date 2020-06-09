module Ranked
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_object, only: %i[up down]
  end

  def up
    @object.rank_up(current_user)
    set_respond
  end

  def down
    @object.rank_down(current_user)
    set_respond
  end

  private

  def set_object
    @object = controller_name.classify.constantize.find(params[:id])
  end

  def set_respond
    respond_to do |format|
      format.json {
        render json: {
          object: @object.class.name,
          id: @object.id,
          rating: @object.ranks.sum(:result),
          rank_result: @object.ranks.find_by(user_id: current_user).present? ? @object.ranks.find_by(user_id: current_user).result : 0
        }
      }
    end
  end
end