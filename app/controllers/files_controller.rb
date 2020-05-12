class FilesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @file.purge

    respond_to do |format|
      format.js {render inline: "location.reload();" }
    end
  end

end