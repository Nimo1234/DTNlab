# Object for Simulated Node
class Node
  def initialize()
    @memory = Hash.new # Memory of the node
	@count_recv = 0 
	@count_tmit = 0 
  end

  def store(id_data, size)
    @memory[id_data] = size
  end

  def show_memory()
    mem_total = 0
    @memory.each_pair do |k,v|
      mem_total += v
    end
    return(mem_total)
  end

end


def process_GENDATA(nodes, data)
  # Time, EventType, DataId, GeneratorId, Transmitting Size
  # 178.0,GENDATA,Data00000143,sensor-033,1024,

  # Extract necessary information from Eventlist
  id_data = data[2]
  id_gene = data[3]
  size = data[4].to_i

  # nodes creation (preparation)
  if (nodes[id_gene] == nil) then # firstly appeared
    nodes[id_gene] = Node.new
  end

  # Simulating for data storing in generation
  nodes[id_gene].store(id_data, size)
 
end

def process_RECVDATA(nodes, data)
  # Time, EventType, DataId, SenderId, Transmitting Size, ReceiverId
  # 179.0,RECVDATA,Data00000143,sensor-033,1024,station-003
  # p data

  # Extract necessary information from Eventlist
  id_data = data[2]
  id_send = data[3]
  id_recv = data[5]
  size = data[4].to_i

  if (nodes[id_send] == nil) then
    raise # Causing error
  end
  # nodes creation (preparation)
  if (nodes[id_recv] == nil) then # firstly appeared
    nodes[id_recv] = Node.new
  end

  # Simulating for data storing at dst (as id_dst)
  nodes[id_recv].store(id_data, size)

end

def process_BUSARRIVAL(nodes, data)
end



# Data preparation
nodes = Hash.new # Nodes in Simulation

# Main loop for reading Eventlist
while (line = STDIN.gets) do
  data = line.strip.split(",")
  p data

  if (data[1] == "GENDATA") then
    process_GENDATA(nodes, data)
  end

  if (data[1] == "RECVDATA") then
    process_RECVDATA(nodes, data)
  end

  if (data[1] == "BUSARRIVAL") then
    process_BUSARRIVAL(nodes, data)
  end
end

# Output
nodes.each_pair do |k,v|
  printf("%s : %d\n", k, v.show_memory)
end

