class Node
  def initialize()
    @count_trans = 0
    @count_receive = 0
    
    @memory = Hash.new
  end

  def transmit()
    @count_trans += 1
  end

  def receive(id, size)
    @count_receive += 1

    @memory[id] = size
  end

  def show_count_transmit()
    return (@count_trans)
  end

  def show_count_receive()
    return (@count_receive)
  end

  def show_memorysize()
    total = 0
    @memory.each do |k, v|
      total += v
    end

    return(total)
  end
end

def event_TRANSDATA(node, data)
  # ["0.0", "TRANSDATA", "Data00000107", "sensor-027", "1024", "station-002"]
  id_src = data[3]
  id_dst = data[5]
  id_data = data[2]
  size = data[4].to_i

  if (node[id_src] == nil) then
    node[id_src] = Node.new
  end

  node[id_src].transmit()
end

def event_RECVDATA(node, data)
  # 1.0,RECVDATA,Data00000130,sensor-033,1024,station-003
  id_src = data[3]
  id_dst = data[5]
  id_data = data[2]
  size = data[4].to_i

  if (node[id_dst] == nil) then
    node[id_dst] = Node.new
  end

  node[id_dst].receive(id_data, size)
end

node = Hash.new
while (line = STDIN.gets) do
  # ["1.0", "RECVDATA", "Data00000061", "sensor-015", "1024", "station-001"]
  data = line.strip.split(",")
#  p data

  if (data[1] == "TRANSDATA") then
    event_TRANSDATA(node, data) 
  end
  if (data[1] == "RECVDATA") then
    event_RECVDATA(node, data) 
  end

end

node.each_pair do |k, v|
  printf("%s : %d : %d : %d\n",
    k,
    v.show_count_transmit,
    v.show_count_receive,
    v.show_memorysize)
end

