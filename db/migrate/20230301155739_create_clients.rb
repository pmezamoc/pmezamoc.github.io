class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string :email
      t.string :password_digest
      t.integer :company_id
      t.string :firstname
      t.string :lastname

      t.timestamps
    end
  end
end
