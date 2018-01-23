class VideossTable < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.string :description
      t.string :URL
      t.integer :views
    end
  end
end
