# creating Epidemic Routing protocols 
class EpidemicRouter
   def initialize()
     @replicate= 0
     @activerouter=0
   end
   def replicate(data0,event)
     return data0 
   end 
   def exchangeData(data_id,data)
     return data
   end 
 end 
 def epidemicrouter(replicate)
   return epidemicrouter
 end 
 
 # Object for Simulated Node
 # Object for Simulated Node
 class Node
   def initialize()
     @memory = Hash.new # Memory of the node
 	@count_recv = 0 
 	@count_tmit = 0 
   end

   def get(id_data)
     return (@memory[id_data])
   end

   def put(id_data, data)
     @memory[id_data] = data
   end

   def memory()
     return (@memory)
   end

   def show_memory()
     @memory.each_pair do |k,v|
       p v
     end
     return()
   end

 end
 # create simualion time within the time based duration 
 def process_GENDATA(nodes, event)
   # Time, EventType, DataId, GeneratorId, Transmitting Size
   # 178.0,GENDATA,Data00000143,sensor-033,1024,

   # Extract necessary information from Eventlist
   data_creation = event[0].to_i
   id_data = event[2]
   id_gene = event[3]
   size = event[4].to_i

   # nodes creation (preparation)
   if (nodes[id_gene] == nil) then # firstly appeared
     nodes[id_gene] = Node.new
   end

   # Simulating for data storing in generation
   data = {"id" => id_data, "size" => size, "creationtime" => data_creation}
   data.each do |key,value|
     #puts "#{key} : #{value}"
   end 
   #puts data["id"]
   #puts data["size"]
   #puts data["creationtime"]

   nodes[id_gene].put(id_data, data)
 end
 

 def process_TRANSDATA(nodes, event)
   # Time, EventType, DataId, SenderId, Transmitting Size, ReceiverId
   # 179.0,RECVDATA,Data00000143,sensor-033,1024,station-003
   # p data

   # Extract necessary information from Eventlist
   id_data = event[2]
   size = event[3].to_i
   id_send = event[4]
   #p id_send
   id_recv = event[5]

   # nodes creation (preparation)
   if (nodes[id_recv] == nil) then # firstly appeared
     nodes[id_recv] = Node.new
   end

   # Simulating for data storing at dst (as id_dst)
 #  nodes[id_recv].store(id_data, size)
 # 1. take data id_data from id_send
   data = nodes[id_send].get(id_data)
   #p  data 
 # 2. put the data id_data to id_recv
   nodes[id_recv].put(data["id"], data)

 end

 def process_BUSSTOP(nodes, event)
     node1 = event[2]
     #p node1
     node2 = event[3]
     #p node2
     contacttime = event[4].to_i

     # nodes creation (preparation)
     if (nodes[node1] == nil) then # firstly appeared
       nodes[node1] = Node.new
     end
     if (nodes[node2] == nil) then # firstly appeared
       nodes[node2] = Node.new
     end
  
 	### Routing Decision ###
     # 1. Check data on node1
     tmp1 = nodes[node1].memory()
     # 2. Check data on node2
     tmp2 = nodes[node2].memory()
    
    

    
#####3############################################modified code 
# exchange or tranfer data from node1 to node2=> from event[3] to event[2]
    
     sender_id = event[3]
     #p sender_id
     data_id = tmp2.keys.sort
     data_id = tmp2.values 
     p data_id.to_a
     p data_id.to_a
     id_recv = event[2]
    
     puts tmp2.length
     puts tmp2.keys
     puts tmp2.values 
     number_data=0
     tmp2.each_key { |k| p k }
     tmp1.each_value { |v| p v }
     
=begin
     tmp2.each do |element,count|
       puts "#{element} :#{count}"
       tmp1=tmp2
       
       number_data+=1
       puts "#{number_data}"
     end 
     tmp1.each do |elem,cnt| 
       puts "#{elem} : #{cnt}" 
     end 
=end 
   tmp3= nodes[node1].put(id_recv,data_id)
    p tmp3
   tmp4= nodes[node1].memory()
   p tmp4

  
##############################################################  

     
     #tmp1=nodes[node2].memory()
  def sendData(node2,node1)
  end 

  def getData(id_recv)
  end 
     
     
     
    
     
     #p tmp2.size
     #p tmp2.bytes 

     # 3. ???

 end

 def update(tmp1)
   p tmp1
 end 

 # Data preparation
 nodes = Hash.new # Nodes in Simulation
 datas = Hash.new # Datas in Simulation

 # Main loop for reading Eventlist
 while (line = STDIN.gets) do
   event = line.strip.split(",")
 #  p data

   if (event[1] == "GENDATA") then
     process_GENDATA(nodes, event)
   end

   if (event[1] == "TRANSDATA") then
     process_TRANSDATA(nodes, event)
   end

   if (event[1] == "BUSSTOP") then
     process_BUSSTOP(nodes, event)
   end
 end

 exit

 # Output
 nodes.each_pair do |k,v|
   printf("%s : \n", k)
   puts nodes[k].memory()
 end

