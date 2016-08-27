class AddDetailsToPlays < ActiveRecord::Migration
  def change
    add_column :plays, :season, :text
    add_column :plays, :num, :text
  end
end
