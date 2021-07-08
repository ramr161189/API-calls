class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.uuid :user_id
      t.string :password_digest
      t.string :plan
      t.timestamps
    end
  end

  def change
    add_column :apigenerations, :email, :string 
     create_table :apigenerations do |t|
      t.string :email
      t.string :apikey
      t.string :usage
      t.string :plan
      t.timestamps
    end
  end

  def change
     create_table :jsondata do |t|
      t.string :word
      t.string :definitions
      t.string :synonyms
      t.string :antonyms
      t.string :examples
      t.timestamps
  end
end
