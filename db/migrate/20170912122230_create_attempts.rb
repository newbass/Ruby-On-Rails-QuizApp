class CreateAttempts < ActiveRecord::Migration[5.1]
  def change
    create_table :attempts do |t|
      t.integer :uid
      t.integer :qid
      t.integer :success
      t.integer :state

      t.timestamps
    end
  end
end
