ActiveAdmin.register Like do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params like: [:sightings_id, :user_id]
# permit_params :sightings_id, :user_id

#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  controller do
    def permitted_params
      params.permit(like: [:sighting_id, :user_id])
    end
  end

end
