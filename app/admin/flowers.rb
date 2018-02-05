ActiveAdmin.register Flower do

  # menu priority: 2
  config.per_page = 10

  permit_params :id, :name, :latin_name, :features, :description, :profile_picture, :favourites_attributes => [:user_id]

  index do
    id_column
    column :name
    column :latin_name
    column :features
    column :description
    column :profile_picture_file_name
    column 'Favourites Count' do |flower|
      flower.favourites.count
    end

    actions
  end

  filter :id
  filter :name
  filter :latin_name
  filter :features
  filter :description

  form :html => { :enctype => 'multipart/form-data'} do |f|
    f.inputs 'Details' do
      f.input :name
      f.input :latin_name
      f.input :features
      f.input :description
      f.input :profile_picture, as: :file
    end
    f.actions
  end

end