module ApplicationHelper
  def full_title page_title = ""
    base_title = t "app_name"
    page_title.empty? ? page_title : page_title + "|" + base_title
  end
end
