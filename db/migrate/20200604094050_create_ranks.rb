class CreateRanks < ActiveRecord::Migration[6.0]
  def change
    create_table :ranks do |t|
      t.integer :result
      t.references :rankable, polymorphic: true, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
