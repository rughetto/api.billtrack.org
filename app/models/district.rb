class District < ActiveRecord::Base
  # ATTRIBUTES --------------------
  # t.string  :number
  # t.integer :state      
  
  # RELATIONSHIPS -----------------
  def state 
    @state ||= State.first(:conditions => {:code => self[:state] })
  end 
   
  def state=( code )  
    if code.class == String   
      self[:state] = code
    elsif code.class == State 
      self[:state] = code.code
    else 
      raise ArgumentError, "must be State object or string identifying code"  
    end    
  end  
  
  has_many :district_maps  
  named_scope :untreated, :conditions => {:latitude => nil}

  # HOOKS -------------------------
  after_destroy :reset_state_counter_cache
  after_save :reset_state_counter_cache
  def reset_state_counter_cache  
    if state
      state.district_count_will_change!
      state.save
    end  
  end  
  
  # VALIDATIONS -------------------
  def validate
    # must be a unique pair
    limit = new_record? ? 0 : 1
    unless self.class.count(:all, :conditions => {:state => self.state, :number => self.number} ) <= limit
      errors.add_to_base("must have a unique combination of state and district number")
      return false
    end  
  end  
  
  
  # CACHING -----------------------
  include PoorMansMemecache
  cache_on_keys :state, :number
  
  
  # FINDERS ETC -------------------
  # finder method that looks for the unique pair, state and number
  def self.find_or_create(st, num)
    all.select{|rec| rec.state == st && rec.number == num.to_i }.first || create(:state => st, :number => num)
  end  
  
  # INSTANCE METHODS --------------
  # js polygon outlines from mcommons.com!
  def get_polygon_js 
    if state.district_count > 1
      begin
        url = "http://congress.mcommons.com/districts/polygon.js?state=#{self[:state]}&district=#{self.number}&level=federal"
        response = Net::HTTP.get_response( URI.parse( url ) ) 
        self.js_outline = response.body if response
      rescue
        logger.error( "unable to get js outline for state=#{self[:state]} and district=#{self.number}" )
       end     
    end  
  end 
  
  def self.get_all_polygons   
    all.each do |district|
      district.get_polygon_js
      district.save
    end  
  end 
  
  def set_geo_center 
    positions = district_maps.collect do |dm| 
      lat = dm.latitude ? dm.latitude.to_f : dm.latitude 
      long = dm.longitude ? dm.longitude.to_f : dm.longitude 
      [lat, long] unless lat.nil? || long.nil?  
    end 
    positions.delete( nil ) 
    if positions.size > 0  
      summed = positions.inject do | result_arr, arr | 
        [result_arr[0] + arr[0], result_arr[1] + arr[1]]
      end  
      avged = summed.collect{ |sum| sum/positions.size.to_f }   
      self.latitude = avged[0]
      self.longitude = avged[1]       
    else  
      self.latitude = state.latitude
      self.longitude = state.longitude
    end    
    self
  end 
  
  def self.set_geo_centers  
    untreated.each do |district|  
      district.set_geo_center
      district.save
    end  
  end  
  
    
  
end  
