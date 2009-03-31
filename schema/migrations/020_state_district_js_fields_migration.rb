class StateDistrictJsFieldsMigration < ActiveRecord::Migration
  def self.up    
    add_column :states, :district_count, :integer, :default => 0
    add_column :districts, :js_outline, :text 
    add_column :districts, :latitude, :string
    add_column :districts, :longitude, :string
    add_column :district_maps, :latitude, :string
    add_column :district_maps, :longitude, :string
  end

  def self.down   
    remove_column :states, :district_count
    remove_column :districts, :js_outline   
    remove_column :districts, :latitude
    remove_column :districts, :longitude  
    remove_column :district_maps, :latitude
    remove_column :district_maps, :longitude
  end
end
