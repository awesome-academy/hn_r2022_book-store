class Admin::OrdersController < Admin::AdminController
  before_action :load_and_search_orders, only: %i(index update destroy)
  load_and_authorize_resource

  def index; end

  def update
    ActiveRecord::Base.transaction do
      @order.public_send("status_#{params[:status]}!")
      flash[:success] = t "success"
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "update_fail"
    redirect_to admin_orders_path
  end

  def destroy
    update_book_quantity_for_order_delete @order unless @order.status_accepted?

    if @order.destroy
      flash[:success] = t "success"
      respond_to do |format|
        format.js
      end
    else
      flash.now[:danger] = t "delete_fail"
    end
  end

  private

  def load_and_search_orders
    @search = Order.ransack params[:q]
    @pagy, @orders = pagy @search.result.without_init_status.newest,
                          items: Settings.orders_per_page
  end
end
