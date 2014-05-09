cd /vagrant/GSN_old_push/gsn
	
sudo mv /var/lib/neo4j/data/graph.db /tmp
sudo cat /vagrant/GSN_old_push/gsn/cypher.txt | /var/lib/neo4j/bin/neo4j-shell neo4j.properties -path /var/lib/neo4j/data/graph.db > /var/lib/neo4j/data/log/db_init.log
bundle exec rake neo4j:start
	