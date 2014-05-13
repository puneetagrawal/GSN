/**
 * A random graph is generated and stored in the "graph" variable, and then sigma is
 * instanciated directly with the graph.
 *
 * The simple instanciation of sigma is enough to make it render the graph
 * on the screen, since the graph is given directly to the constructor.
 */

 // graph_data = JSON.parse('<%#= raw [@users.to_json][0] %>')

// Add a method to the graph model that returns an
  // object with every neighbors of a node inside:

  // sigma.classes.graph.addMethod('neighbors', function(nodeId) {
  //   var k,
  //       neighbors = {},
  //       index = this.allNeighborsIndex[nodeId] || {};

  //   for (k in index)
  //     neighbors[k] = this.nodesIndex[k];

  //   return neighbors;
  // });

var load_graph = function(graph_data, node_ids){

	
sigma.renderers.def = sigma.renderers.canvas
// Instanciate sigma:
s = new sigma({
  graph: graph_data,
  container: 'graph-container'
});

// Initialize the dragNodes plugin:
sigma.plugins.dragNodes(s, s.renderers[0]);

// Bind the events:
s.bind('doubleClickNode', function(e) { 
// s.bind('overNode', function(e) { 
  var attr_node = ""
  var attr_edge = ""
  var edge_property = e.data.node.properties.edge
  var inc = 0;
  
  if(edge_property.relation_id != undefined) {
    edge_prop = ''
    $.each(edge_property.relation_id, function(key, relation_id) {     
       edge_prop += relation_html(key, relation_id, edge_property.relation_name[inc])
       inc++
     });
    $("#edge_prop_tooltip").attr('data-original-title', edge_prop)
 }

   if(e.data.node.properties.edge != undefined) {
     $.each(e.data.node.properties.edge, function(k, v) {
      attr_edge += "<li><span style='color:red; margin-right: 20px;'>"+k+":</span><span>"+v+"</span></li>"
    });
   }

  label = e.data.node.label.split(' ')[0]
   switch(label){
    case 'User': 
       attr_node = get_user_data(e, attr_node)
      break; 
    case 'UserIdentity':
       attr_node = get_user_identity_data(e, attr_node) 
       break; 
    case 'Provider': 
      attr_node = get_provider_data(e, attr_node)
      break; 
    case 'Group': 
      attr_node = get_group_data(e, attr_node)
      break; 
    case 'GroupType': 
      attr_node = get_group_type_data(e, attr_node)
       break; 
    case 'NodeType': 
      attr_node = get_node_type_data(e, attr_node)
      break; 
    case 'NodeAttribute': 
      attr_node = get_node_attribute_data(e, attr_node)
      break; 
  }

  $("#myModalLabel").html(e.data.node.label);
  $("#modal_body_content").html(attr_node);
  $("#nodeModal").modal("show");
  
});


var get_user_data = function(e, attr_node){
  node_prop = ''
  $.each(e.data.node.properties.node, function(k, v) {    
    if(k =='first_name' || k=='last_name' || k=='country') {
      attr_node += node_html(k, v)
    }
    node_prop += node_html(k, v)
  }); 
  $("#node_prop_tooltip").attr('data-original-title', node_prop)
  return attr_node; 
}

var get_user_identity_data = function(e, attr_node){
  node_prop = ''
  $.each(e.data.node.properties.node, function(k, v) {
    if(k=='email' || k=='nickname' || k=='country') {
      attr_node += node_html(k, v)
    }
    node_prop += node_html(k, v)
  });
  $("#node_prop_tooltip").attr('data-original-title', node_prop) 
  return attr_node;  
}

var get_provider_data = function(e, attr_node){
  node_prop = ''
  $.each(e.data.node.properties.node, function(k, v) {
    if(k=='provider_name') {
      attr_node += node_html(k, v)
    }
    node_prop += node_html(k, v)
  }); 
  $("#node_prop_tooltip").attr('data-original-title', node_prop)
  return attr_node;  
}

var get_group_data = function(e, attr_node){
  node_prop = ''
  $.each(e.data.node.properties.node, function(k, v) {
    if(k!='created_at' && k!='updated_at' && k!='color' && k!='uuid' && k!='id' ) {
      attr_node += node_html(k, v)
    }
    node_prop += node_html(k, v)
  }); 
  $("#node_prop_tooltip").attr('data-original-title', node_prop)
  return attr_node;  
}

var get_group_type_data = function(e, attr_node){
  node_prop = ''
  $.each(e.data.node.properties.node, function(k, v) {
    // if(k=='provider_name') {
      attr_node += node_html(k, v)
    // }
  }); 
  $("#node_prop_tooltip").attr('data-original-title', attr_node)
  return attr_node;  
}

var get_node_type_data = function(e, attr_node){
  node_prop = ''
  $.each(e.data.node.properties.node, function(k, v) {
    if(k=='field_name') {
      attr_node += node_html(k, v)
    }
    node_prop += node_html(k, v)
  }); 
  $("#node_prop_tooltip").attr('data-original-title', node_prop)
  return attr_node;  
}

var get_node_attribute_data = function(e, attr_node){
  node_prop = ''
  $.each(e.data.node.properties.node, function(k, v) {
    if(k=='name' ||  k==attr_type) {
      attr_node += node_html(k, v)
    }
    node_prop += node_html(k, v)
  }); 
  $("#node_prop_tooltip").attr('data-original-title', node_prop)
  return attr_node;  
}


var node_html = function(property, value){
 return "<li><span style='color:red; margin-right: 20px;'>"+capitalize_str(property)
+":</span><span>"+value+"</span></li>"
}

var relation_html = function(key, relation_id, relation_name){
 return "<li><span style='color:red; margin-right: 20px;'>"+capitalize_str(relation_id)
+":</span><span>"+relation_name+"</span></li>"

}


var capitalize_str = function(str){
  str = str.toLowerCase().replace("_", " ").replace(/\b[a-z]/g, 
  function(letter) {
    return letter.toUpperCase();
  });
  return str;
} 


s.bind('clickNode', function(e) {    

  // console.log(e.data.node.id)
  $.ajax({
    type: "GET",
    url: "/users/"+ e.data.node.id +"/show_other_node?node_ids="+node_ids
      
  }).done(function(data) {
    // graph_data = JSON.parse("<%#= raw [data.to_json][0] %>")
   
    data[0].nodes.forEach(function(n){
      s.graph.addNode(n)
    });

    data[0].edges.forEach(function(e){
      s.graph.addEdge(e)
    });

    data[1].forEach(function(d){
      if ($.inArray(d, node_ids) == -1)
      {
        node_ids.push(d)
      }
      
    });
  s.refresh();

});
  s.refresh();

});
}