module API
  module V1
    class Books < Grape::API
      include API::V1::Defaults

      helpers do
        def find_book id
          @book = Book.find_by id: id

          return @book if @book

          error!("Books not found", 404)
        end

        def require_admin!
          return error!("User must be admin", 403) unless @current_user&.admin?
        end
      end

      before do
        authenticate_user!
        require_admin!
      end

      resource :books do
        desc "Return all books"
        get "", root: :books do
          Book.all
        end

        desc "Return a book"
        params do
          requires :id, desc: "ID of the book"
        end
        get ":id", root: :book do
          find_book params[:id]
        end
      end

      resource :books do
        desc "Create a book"
        params do
          requires :name, type: String, desc: "Name of book"
          optional :description, type: String, desc: "Description of book"
          requires :num_pages, type: String, desc: "Nums of page"
          requires :price, type: String, desc: "price of book"
          requires :quantity, type: String, desc: "quantity of book"
          requires :publish_year, type: DateTime, desc: "publish year of book"
          requires :publisher_id, type: String, desc: "publisher id of book"
          requires :category_id, type: String, desc: "category id of book"
        end
        post "", root: "book" do
          @book = Book.new params
          if @book.save
            present success: @book
          else
            error!("create fails", 401)
          end
        end
      end

      resource :books do
        desc "Update a book"
        patch ":id", root: "book" do
          find_book params[:id]
          if @book.update params
            present success: "Update successful"
          else
            error!("update fails", 401)
          end
        end

        desc "Delete a book"
        delete ":id", root: "book" do
          find_book params[:id]
          if @book.destroy
            present success: "Delete successful"
          else
            error!("Delete fails", 401)
          end
        end
      end
    end
  end
end
