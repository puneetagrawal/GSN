namespace :db_data do
  desc "Add default data"
  task add: :environment do
      node_attributes = [
		 {name: 'string', attr_type: 'DataType'}, 
		 {name: 'mandatory', attr_type: 'Requirement'},
		 {name: 'public', attr_type: 'Visibility'}
		 ]
	  created_attributes = []
	  node_attributes.each do |na|
	  	 existing_node_attribute = NodeAttribute.find(na)
	  	  if existing_node_attribute.present?
	  	  	created_attributes << existing_node_attribute
	  	  else
	  	  	created_attributes << NodeAttribute.create(na)
	  	  end	    
	  end  
	  [{field_name: 'name'}, {field_name: 'description'}].each do |nt|
	  	 node_type = NodeType.create(nt)	
	  	 created_attributes.each do |attr|
	  	   node_type.properties << attr
	  	 end
	  end

	  ['normal', 'facebook', 'twitter', 'linkedin', 'gplus'].each do |provider|	  	
	  	 Provider.create(provider_name: provider)
	  end
	 
    puts "Data load succesfully"
  end

end
