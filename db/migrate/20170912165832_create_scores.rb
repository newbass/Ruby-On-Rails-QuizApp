class CreateScores < ActiveRecord::Migration[5.1]
  def change
    create_table :scores do |t|
      t.integer :uid
      t.integer :sid
      t.integer :state
      t.integer :score

      t.timestamps
    end
  end
end
