module FoodItemsHelper
  def activate_link_text(activatable)
    activatable.active? ? 'Deactivate' : 'Activate'
  end

  def is_active_text(activatable)
    activatable.active? ? 'Currently Active' : 'Currently Not Active'
  end
end
