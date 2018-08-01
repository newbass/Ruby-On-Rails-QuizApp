class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string :question
      t.string :optiona
      t.string :optionb
      t.string :optionc
      t.string :optiond
      t.string :correctoption
      t.string :subgenre
      t.string :genre

      t.timestamps
    end
  end
end
