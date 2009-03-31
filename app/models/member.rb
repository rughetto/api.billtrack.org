class Member < ActiveRecord::Base
  #self.abstract_class = true
  establish_connection Merb::Orms::ActiveRecord.configurations["member_#{Merb.env}".to_sym]
  
  # ATTRIBUTES ------------------
  # username
  # salt
  # crypted_password
  # timestamps
  
  # auth_token # used for verification, then for remember token
  # remember_until
  
  # status
  # roles

  # first_name
  # last_name
  # visibility
  # address
  # zipcode
  # party_affilation
  
  # NOTES ------------------------
  # status  = psuedo state machine, maybe a status model
  # create remember_me functionality
  # create activation functionality, check out related slices
  # role verification system, maybe a role model
  # visibility model/fuctionality that reads the field and determines visibility
  #   also should cache result somehow
  
end
