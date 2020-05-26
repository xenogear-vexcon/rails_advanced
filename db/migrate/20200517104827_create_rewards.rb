class CreateRewards < ActiveRecord::Migration[6.0]
  def change
    create_table :rewards do |t|
      t.string :title, null: false
      t.references :question, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
