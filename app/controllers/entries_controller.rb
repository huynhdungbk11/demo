class EntriesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def show
    @entry = Entry.find(params[:id])
    @comments = @entry.comments
  end

  def edit
    @entry = Entry.find(params[:id])
  end

  def update
    @entry = Entry.find(params[:id])
    if @entry.update_attributes(entry_params)
        flash[:success] = "Edited"
      redirect_to root_url
    else
      render 'edit'
    end
  end


  def create
  	@entry = current_user.entries.build(entry_params)
  	if @entry.save
  		flash[:success] = "Entry created!"
  		redirect_to root_url
  	else
      @feed_items = []
  		render 'static_pages/home'
  	end
  end

  def destroy
    @entry.destroy
    flash[:success] = "Entry deleted"
    redirect_to request.referrer || root_url
  end

  private

  	def entry_params
  		params.require(:entry).permit(:content, :title)
  	end

    def correct_user
      @entry = current_user.entries.find_by(id: params[:id])
      redirect_to root_url if @entry.nil?
    end
end
