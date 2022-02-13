class Order < ApplicationRecord
  enum status: {init: 0, in_progress: 1,
                accepted: 2, rejected: 3}, _prefix: true
  belongs_to :user
  has_many :order_details, dependent: :destroy
  has_many :books, through: :order_details
  before_save :update_total_price
  scope :newest, ->{order created_at: :desc}
  scope :without_init_status, ->{where.not(status: statuses[:init])}
  delegate :name, to: :user, prefix: true, allow_nil: true

  validates :status, inclusion: {in: statuses.keys}

  private

  def order_total_price
    order_details.map{|od| od ? calc_total(od) : 0}.sum
  end

  def calc_total order_detail
    order_detail.order_quantity * order_detail.price_at_order
  end

  def update_total_price
    self[:total_price] = order_total_price
  end
end
