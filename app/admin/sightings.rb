ActiveAdmin.register Sighting do

  # menu priority: 5
  config.per_page = 10

  permit_params :id, :flower, :user, :name, :description, :latitude, :longitude, :picture, :comments_attributes => [:user_id, :comment], :likes_attributes => [:user_id]

  index do
    id_column
    column :flower
    column :user
    column :name
    column :description
    column :latitude
    column :longitude
    column 'Picture' do |sighting|
      sighting.picture_file_name
    end
    column 'Comments Count' do |sighting|
      sighting.comments.count
    end
    column 'Likes Count' do |sighting|
      sighting.likes.count
    end

    actions
  end

  filter :id
  filter :flower
  filter :user
  filter :name
  filter :description
  filter :latitude
  filter :longitude

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Details" do
      f.input :name
      f.input :description
      f.input :flower
      f.input :user
      f.input :latitude
      f.input :longitude
      f.input :picture, as: :file
    end
    f.actions
  end

  controller do
    def create
      @sighting = Sighting.new(sighting_params)
      @sighting.save!
      redirect_to admin_sightings_path
    rescue StandardError => e
      render html: "<div>#{e.message}</div>".html_safe
    end

    private
    def sighting_params
      params.require(:sighting).permit(:name, :description, :user_id, :flower_id, :latitude, :longitude, :picture)
    end
  end

end
