class CommentsController < ApplicationController
	def new
		before_action :logged_in_user, only: [:create, :edit, :update, :destroy]
  		before_action :correct_user,   only: [:destroy, :edit, :update]
	end

	def create
		@comment = current_user.comments.build(comment_params)
		if @comment.save
			flash[:success] = "Commented!"
			redirect_to :back
		else
      		redirect_to :back
      	end
	end

	def destroy
    	Comment.find(params[:id]).destroy
    	flash[:success] = "Comment was deleted"
    	redirect_to request.referrer || root_url
  	end

  	def edit
    	@comment = Comment.find(params[:id])
  	end

  	def update
    	@comment = Comment.find(params[:id])
    	if @comment.update_attributes(comment_params)
      		flash[:success] = "Edited"
      		redirect_to root_url
    	else
      		render 'edit'
    	end
  	end

	private

	def comment_params
		params.require(:comment).permit(:content, :entry_id)
	end

	def correct_user
		@comment = correct_user.comments.find_by(id: params[:id])
		redirect_to root_url if @comment.nil?
	end

	def find_entry
		@entry = Entry.find(params[:entry_id])
	end
end
