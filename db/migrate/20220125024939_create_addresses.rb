class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :address
      t.boolean :default_address, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
