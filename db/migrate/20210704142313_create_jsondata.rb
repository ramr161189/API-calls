class CreateJsondata < ActiveRecord::Migration[6.1]
  def change
    create_table :jsondata do |t|
      t.jsonb :data

      t.timestamps
    end
  end
end
