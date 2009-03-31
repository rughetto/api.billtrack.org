class GoogleMapper
  
  def self.api_key
    if Merb.env == 'production'
      'ABQIAAAABeYBq_RBHX8zH3h9eRIULxQxRnJ4Q2Zc2rji2sbmhJunADIP6xTaw-hBugO0VZ33vtupBaChuKR5bg'
    else
      'ABQIAAAABeYBq_RBHX8zH3h9eRIULxT-ZTKVLgdLz0ZRRJYP7ttYbtpFeBQxMOT8XSoW3gvdQqx-7gYRCs5f0Q'
    end
  end   
end  