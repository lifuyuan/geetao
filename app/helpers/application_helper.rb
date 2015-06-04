module ApplicationHelper

  def commentable_comment_path(comment_id)
    commentable = Comment.find(comment_id).commentable
    case commentable.class.name.underscore
    when "trip"
      "#{trip_path(commentable)}"
    end
  end

  def dest_state_desc(dest_state)
    Trip::DEST_STATE.find {|a| a.last == dest_state}.first
  end
end
