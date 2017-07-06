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
	tmp = data.dup
    tmp["relaycount"] += 1
    @memory[id_data] = tmp
  end

  def expire(id_data)
	@memory.delete(id_data)
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

  def inc_tmit()
    @count_tmit += 1
  end

  def inc_recv()
    @count_recv += 1
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
  data = {"id" => id_data, "size" => size, "creationtime" => data_creation, "relaycount" => 0}

  nodes[id_gene].put(id_data, data)
  printf("%d GENERATION %s %d\n",
    data_creation, id_data, size)

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
	time = event[0]
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
	ids1 = tmp1.keys
	ids2 = tmp2.keys

	copydata_2to1 = ids2 - ids1
	copydata_1to2 = ids1 - ids2

	printf("%d COPY %s (%d/%d) -> %s (%d+%d=%d)\n",
		time, node1, copydata_1to2.size, tmp1.size,
		node2, tmp2.size, copydata_1to2.size, tmp2.size+copydata_1to2.size)
	printf("%d COPY %s (%d/%d) -> %s (%d+%d=%d)\n",
		time, node2, copydata_2to1.size, tmp2.size,
		node1, tmp1.size, copydata_2to1.size, tmp1.size+copydata_2to1.size)

	printf("%d REPLICATION %d\n", time, copydata_1to2.size + copydata_2to1.size)

	copydata_2to1.each do |dataid| # copy node2 to node1
		data = nodes[node2].get(dataid)
		nodes[node1].put(dataid, data)

		nodes[node2].inc_tmit()
		nodes[node1].inc_recv()
	end

	copydata_1to2.each do |dataid| # copy node1 to node2
		data = nodes[node1].get(dataid)
		nodes[node2].put(dataid, data)

		nodes[node1].inc_tmit()
		nodes[node2].inc_recv()
	end

	if (node2 == $node_internet) then
	    copydata_1to2.each do |dataid| # check received data
			data = nodes[node2].get(dataid)
         	printf("%d SUCCESS %s %d %d %d\n",
          	    time.to_i, data["id"], data["size"],
				time.to_i-data["creationtime"],
				data["relaycount"])

            $count_success += 1
        end
	end

	########################
end


#
$node_internet = "station-004"
$count_success = 0

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

printf("SUCCESS: %d\n", $count_success)
exit

# Output
nodes.each_pair do |k,v|
  printf("%s : \n", k)
  p nodes[k].memory()
end




