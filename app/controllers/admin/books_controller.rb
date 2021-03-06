class Admin::BooksController < Admin::AdminController
  before_action :load_and_search_books, only: %i(index destroy)
  load_and_authorize_resource

  def index; end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new book_params
    @book.publish_year = DateTime.new(params[:book]["publish_year(1i)"].to_i)
    attach_image
    if @book.save
      flash[:success] = "Book created successfully"
      redirect_to admin_books_path
    else
      flash.now[:danger] = "Book created fail"
      render :new
    end
  end

  def edit; end

  def update
    if @book.update book_params
      flash[:success] = "Book updated successfully"
      redirect_to admin_books_path
    else
      flash.now[:danger] = "Book updated fail"
      render :edit
    end
  end

  def destroy
    if @book.destroy
      flash[:success] = t "success"
      respond_to do |format|
        format.js
      end
    else
      flash.now[:danger] = t "delete_fail"
    end
  end

  private

  def book_params
    params.require(:book)
          .permit(:name, :description, :num_pages, :price, :image,
                  :puslish_year, :quantity, :publisher_id, :category_id,
                  book_authors_attributes: [:id, :author_id, :_destroy])
  end

  def load_and_search_books
    @search = Book.ransack params[:q]
    @pagy, @books = pagy @search.result.newest,
                         items: Settings.books_per_page
  end

  def attach_image
    return if params.dig(:book, :image).blank?

    @book.image.attach params.dig(:book, :image)
  end
end
