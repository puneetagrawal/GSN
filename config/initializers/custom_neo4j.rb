module CustomNeo4j
	# def new_labels(*labels)	
	# 	id = self.neo_id
		# MATCH (n { name : "dfdfsd" })
  #       SET n :German
  #       RETURN n;		
 
	# end

  # def new_labels(*labels) 
  #   id = self.neo_id
  #   Rails.logger.debug ":::::::::::::::::::::::::::::::::::::::::::::::"
  #   Rails.logger.debug labels.inspect
  #   Rails.logger.debug id
  #   label = labels[0].to_sym
  #   # Rails.logger.debug Neo4j::Cypher.query{"MATCH (n) WHERE id(n) = #{id} SET n #{label} RETURN n;"}.to_s
  #   Rails.logger.debug Neo4j::Cypher.query{'MATCH (n { nickname : "puneetong" }) SET n :dsasdsda RETURN n;'}.to_s
  #   Rails.logger.debug Neo4j::Cypher.query{'START n= node(1837) SET n :dadad RETURN n;'}.to_s
      
#       match (n {id:1})
# set n :newLlabel
# return n 

  # end

  ATTRIBUTE_TYPES = ['Visibility', 'DataType', 'Requirement']
  
	class << self
  		def first
     		all.map{|u| u}[0]
    	end

    	def last
       		count = all.count
       		all.map{|u| u}[count - 1]
    	end
  	end
end