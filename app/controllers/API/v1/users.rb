module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults

      helpers do
        def find_user id
          @user = User.find_by id: id

          return @user if @user

          error!("User not found", 404)
        end
      end

      resource :users do
        desc "Return all users"
        get "", root: :users do
          authenticate_user!
          User.all
        end

        desc "Return a user"
        params do
          requires :id, type: String, desc: "ID of the user"
        end
        get ":id", root: "user" do
          authenticate_user!
          find_user params[:id]
        end
      end

      resource :users do
        desc "Create a user"
        params do
          requires :name
          requires :email
          requires :password
          requires :password_confirmation
        end
        post "", root: "user" do
          @user = User.new params
          if @user.save
            present success: "Create successfully"
          else
            error!("create fails", 401)
          end
        end
      end

      resource :users do
        desc "Update a user"
        patch ":id", root: "user" do
          authenticate_user!
          find_user params[:id]
          if @user.update params
            present success: "Update successful"
          else
            error!("update fails", 401)
          end
        end

        desc "Delete a user"
        delete ":id", root: "user" do
          authenticate_user!
          find_user params[:id]
          if @user.destroy
            present success: "Delete successful"
          else
            error!("Delete fails", 401)
          end
        end
      end
    end
  end
end
