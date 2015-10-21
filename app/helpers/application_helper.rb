module ApplicationHelper


  def login_or_logout

    if current_author
      link_to 'Sign Out', destroy_author_session_path, method: :delete
    else
      link_to 'Sign In', new_author_session_path
    end
  end
end
