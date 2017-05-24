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
  id_recv = event[5]

  # nodes creation (preparation)
  if (nodes[id_recv] == nil) then # firstly appeared
    nodes[id_recv] = Node.new
  end

  # Simulating for data storing at dst (as id_dst)
#  nodes[id_recv].store(id_data, size)
# 1. take data id_data from id_send
  data = nodes[id_send].get(id_data)
# 2. put the data id_data to id_recv
  nodes[id_recv].put(data["id"], data)

end

def process_BUSSTOP(nodes, event)
    node1 = event[2]
    node2 = event[3]
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

    # 3. ???

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
  p nodes[k].memory()
end

