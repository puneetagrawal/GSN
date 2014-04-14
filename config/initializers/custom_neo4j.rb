module CustomNeo4j
	# def new_labels(*labels)	
	# 	id = self.neo_id
	# 	MATCH (n { name: 'Stefan' })
 #        SET n :German
 #        RETURN n;		

	# end
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