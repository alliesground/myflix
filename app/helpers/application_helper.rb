module ApplicationHelper
  def options_for_video_rating(selected=nil)
    options_for_select((1..5).reverse_each.map{|i| [pluralize(i, "Star"), i]}, selected)
  end
end
