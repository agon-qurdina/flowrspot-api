ActiveAdmin.register User do

  permit_params :id, :email, :first_name, :last_name, :date_of_birth, :profile_picture

  index do
    id_column

    column :id
    column :email
    column :first_name
    column :last_name
    column :date_of_birth
    column 'Profile Picture' do |user|
      user.profile_picture_file_name
    end
    column 'Favourite flowers Count' do |user|
      user.favourites.count
    end

    actions
  end

  filter :id
  filter :email
  filter :first_name
  filter :last_name
  filter :date_of_birth

  form do |f|
    f.inputs 'New User' do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :date_of_birth
      f.input :profile_picture
    end
    f.button :Submit
  end

  controller do
    def create
      @user = User.new(user_params)
      generated_password = Devise.friendly_token.first(8)
      @user.password = generated_password
      @user.password_confirmation = generated_password
      @user.save!
      #TODO Send Registration email
      redirect_to admin_users_path
    rescue StandardError => e
      render html: "<div>#{e.message}</div>".html_safe
    end

    private
    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :date_of_birth, :profile_picture)
    end
  end

end
