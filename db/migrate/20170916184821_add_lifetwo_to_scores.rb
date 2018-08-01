class AddLifetwoToScores < ActiveRecord::Migration[5.1]
  def change
    add_column :scores, :lifetwo, :integer
  end
end
