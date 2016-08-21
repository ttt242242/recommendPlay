class AddVecToPlays < ActiveRecord::Migration
  def change
    add_column :plays, :vec, :text
  end
end
