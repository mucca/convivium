class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.references :creator
      t.timestamps
    end
    
    Category.create :name=>"Home"
    Category.create :name=>"Food"
    Category.create :name=>"Gift"
    Category.create :name=>"Holydays"
    Category.create :name=>"Transports"
    Category.create :name=>"Health"
  end

  def self.down
    drop_table :categories
  end
end
