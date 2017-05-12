
require './objects.rb'
require 'csv' 

n=4# Is the number  of events 
t=0.05
lamda=(n/t)*(t/1000)#INTERVAL time of bus at every station

#Mean Arrival Time = 5 minutes = 5/60th hours
#Mean Arrival Rate = 60/5 = 12 customers per hour
#inter_arrival_time = 8/10 # If 10  buses arrive at station  every 8 hours, the time between each arrival is;


def calc_interval(number_events)
	interval = 60.0/number_events # temporal solution, IMPROVE

	return (interval)
end


class Eventlist
	attr_accessor :events

	def initialize()
		@events = Array.new
	end

	def create_GENDATA(time, data_id, sensor_id, datasize)
		# Creating Events
		info = [data_id, sensor_id, datasize]
		event = [time, "GENDATA", info] # [TIME, EVENT_TYPE, INFORMATION]
		@events.push(event)
	end

	
	def create_TRANSDATA(time0, data_id, sensor_id,data_size, station_id)
		# Creating Events
		info = [time0, data_id, sensor_id, data_size, station_id]
		event = [time0, "TRANSDATA", info] # [TIME, EVENT_TYPE, INFORMATION]
		@events.push(event)
	end
  
	def create_RECVDATA(time1, data_id, sensor_id, data_size,station_id)
		# Creating Events
		info = [time1, data_id, sensor_id, data_size, station_id]
		event = [time1, "RECVDATA", info] # [TIME, EVENT_TYPE, INFORMATION]
		@events.push(event)
	end
  
  # arrival and departure bus events
  
  def create_BUSARRIVAL(time0,bus_id,stat_id1,stat_id2)# defining   bus movement model with parameterlist
  		# Creating Events
  		info = [bus_id,stat_id1,stat_id2]
  		event = [time0,"BUSARRIVAL", info] # [TIME, EVENT_TYPE, INFORMATION]
  		@events.push(event)
  	end
  
  
  def create_BUSDEPART(time1,bus_id,stati_id1,stati_id2)# defining   bus movement model with parameterlist
    # Creating Events
  	info = [bus_id,stati_id1,stati_id2]
  	event = [time1,"BUSDEPART", info] # [TIME, EVENT_TYPE, INFORMATION]
  	@events.push(event)
  end 
  
  def create_BUSSTOP(time1,bus_id,statio_id1)# defining   bus movement model with parameterlist
    # Creating Events
  	info = [bus_id,statio_id1]
  	event = [time1,"BUSSTOP", info] # [TIME, EVENT_TYPE, INFORMATION]
  	@events.push(event)
  end 
  
  # create data transmisiion from station to bus 
  
	def create_TRANSDATASTATION(time0, data_id,bus_id,data_size, station_id)
		# Creating Events
		info = [time0, data_id,bus_id, data_size, station_id]
		event = [time0, "TRANSDATASTATION", info] # [TIME, EVENT_TYPE, INFORMATION]
		@events.push(event)
	end
  
	def create_RECVDATABUS(time1, data_id,bus_id,data_size,station_id)
		# Creating Events
		info = [time1, data_id,bus_id,data_size, station_id]
		event = [time1, "RECVDATABUS", info] # [TIME, EVENT_TYPE, INFORMATION]
		@events.push(event)
	end
=begin  
  def create_STOP(time3,station_id)# defining   bus movement model with parameterlist
    # Creating Events
  	info = [station_id]
  	event = [time3, "BUSSTOP", info] # [TIME, EVENT_TYPE, INFORMATION]
  	@events.push(event)
  end
  
  def create_MOVE(time4,station_id)# defining   bus movement model with parameterlist
    # Creating Events
  	info = [station_id]
  	event = [time4, "BUSSTOP", info] # [TIME, EVENT_TYPE, INFORMATION]
  	@events.push(event)
  end
=end 

  
	def sort()
		@events = @events.sort do |a,b| a[0] <=> b[0] end
	end

	def print()
		@events.each do |event|
			p event
		end
	end
	
end


class ArrayObject < Array
  def getInstances(strId)
    elements = self.select do |elem|
		elem.id == strId
  end

	return (elements[0])
end


class ArrayObj < Array
  def getInstances(strId)
    elements = self.select do |elem|
		elem.id == strId
  end

	return (elements[0])
end
end
end   


# Initialization
SIMULATION_DURATION=860.0
NUM_STATIONS=4
NUM_SENSORS=10
NUM_BUSES=2
TIME_FINISH = 180 # Finish time in Seconds
TOTAL_TIME_TRAVEL=110

# Creating Stations and Sensors
list_stations = Array.new
list_sensors = ArrayObject.new
k = 0
for i in 0..(NUM_STATIONS-1) do
	station_id = sprintf("station-%03d", i)
	station = Station.new(station_id)
	list_stations.push(station)
	
	for j in 0..(NUM_SENSORS-1) do
	    sensor_id = sprintf("sensor-%03d", k)
		#sensor = Sensor.new(sensor_id, "Video", 2)
		sensor = Sensor.new(sensor_id, station_id)
		station.add_sensor(sensor)
		list_sensors.push(sensor)

#		printf("Station:[%s] Sensor:[%s]\n", station_id, sensor_id)
		k += 1
	end
end

# Event: Data generation

eventlist = Eventlist.new()
eventlist.sort()
count_data = 0
list_stations.each do |station|
	sensors = station.get_sensors()
	sensors.each do |sensor|
		time = 0.0
		while (time < TIME_FINISH) do
	  		data_id = sprintf("Data%08d", count_data)
	  		data = sensor.create_data(data_id)
	  		interval = sensor.calc_interval()
	  		count_data += 1

			# Creating Events
			eventlist.create_GENDATA(time, data_id, sensor.id, data.size)

			time += interval
		end

	end
end

# adding bus event to eventlist 

# Event(TRANSDATA): Data transmission from Sensor to Station
eventlist.sort()
eventlist.events.each do |event|
  if (event[1] == "GENDATA") then
    #p event
	# check sensor id
	sensor_id = event[2][1]
  
	# find station id from the sensor id
  # find bus id from station id 
	## 1. instance of sensor with the sensor_id
	sensor_obj = list_sensors.getInstances(sensor_id)

  station_id = sensor_obj.station_id
  data_id =event[2][0]
  data_size=event[2][2]


	# create data transfer event from sensor to station
	# [0.0, "GENDATA", ["Data00000170", "sensor-025", 1024]]
	# [time, "TRANSDATA", [Data-ID, Data-originate-sensor-ID, size, Received ID]]
	# Creating Events
  #time0=time
	time0 = event[0]# time generated during the data generation 
	eventlist.create_TRANSDATA(time0, data_id, sensor_id, data_size, station_id)

	time1 = time0+1
	eventlist.create_RECVDATA(time1, data_id, sensor_id, data_size, station_id)
  end

end

eventlist.sort()
eventlist.events.each do |event|
  #p event
end 

### Test output
#eventlist.sort()
#eventlist.events.each do |event|
#  p event
#end
#eventlist.print()


###
# Bus movement

# Bus preparation, Array for keeping bus instances

#@list_buses=Array.new


#p path[0]
# bus-001 arrival and stopping  time at station A 
#p current  
#p path 

list_buses = Array.new # for bus instances
#file=File.new("")
# creating bus array objects 
bus1 = Bus.new("bus-001")
bus2 = Bus.new("bus-002")
#exit


#p list_stations


bus1.add_path("station-001", "station-002",60)# station_id 
bus1.add_stop("station-002",30)# station_id

bus1.add_path("station-002", "station-003",60)# station_id 
bus1.add_stop("station-003",30)# station_id

bus1.add_path("station-003", "station-004",60)# station_id 
bus1.add_stop("station-004",30)# station_id

bus1.add_path("station-004", "station-001",60)# station_id 
bus1.add_stop("station-001",30)# station_id


bus2.add_path("station-003","station-004",60)#
bus2.add_stop("station-004",30)

bus2.add_path("station-004","station-001",60)#
bus2.add_stop("station-001",30)

bus2.add_path("station-001","station-002",60)#
bus2.add_stop("station-002",30)

bus2.add_path("station-002","station-003",60)#
bus2.add_stop("station-003",30)

#list_buses=[bus1,bus2]

bus1_path=bus1.get_path()
bus2_path=bus2.get_path()


#p bus_path
current=0
eventlist.sort()
eventlist.events.each do |event|
  #p event
  end
[bus1_path, bus2_path].each do |bus_path|
  #100.times do |x|
  bus_path.each do |path|
    
    if (path[0]=='STOP') then
    	  eventlist.create_BUSSTOP(current,path[1], path[2])
        current=path[3]+current
      end
   
    if(path[0]=='MOVE') then
      current=path[4]+current
      eventlist.create_BUSDEPART(current, path[1],path[2], path[3])
       current=path[4]+current
      
      eventlist.create_BUSARRIVAL(current, path[1],path[2], path[3])
      current=path[4]+current
      current+=path[4]
     
      end 
    end 
   
  end 
   
  #end
#end 
#end 
  
  
    # Data transmission Event from station To bus within specific data size 
    
    
    
eventlist.sort()
eventlist.events.each do |event|
  [bus1_path, bus2_path].each do |bus_path|
    bus_path.each do |path|   
      if path[0] =='MOVE' 
        #bus_id = event[2][0]
        #p bus_id
        #station_id1=event[2][1]
        #p station_id
    
       if  event[1]=='GENDATA' 
         data_id =event[2][0]
         #p data_id
         data_size=event[2][2]
         #p  data_size
  
        time0 = event[0]# time generated during the data generation 
        eventlist.create_TRANSDATASTATION(time0,path[1],path[2],data_id,data_size)

        time1 = time0+1
        eventlist.create_RECVDATABUS(time1,path[1],path[2],data_id,data_size)
   end 
 end
end 
end
end
#end 
 


  #end

     
eventlist.sort()
eventlist.events.each do |event|
 #p event

  #p event
  #for i in 0..(SIMULATION_DURATION) do
  

  if (event[1] == "GENDATA") then
    printf"#{event[0]},#{event[1]},#{event[2][0]},#{event[2][1]},#{event[2][2]},#{event[2][3]}\n"
  end
  if (event[1] == "TRANSDATA") then
    printf"#{event[2][0]},#{event[1]},#{event[2][1]},#{event[2][2]},#{event[2][3]},#{event[2][4]}\n"
  end
  if (event[1] == "RECVDATA") then
    printf"#{event[2][0]},#{event[1]},#{event[2][1]},#{event[2][2]},#{event[2][3]},#{event[2][4]}\n"
  end

  
  if (event[1] == "BUSARRIVAL") then
    printf"#{event[0]},#{event[1]},#{event[2][0]},#{event[2][1]},#{event[2][2]}\n"
  end

  if (event[1] == "BUSDEPART") then
    printf"#{event[0]},#{event[1]},#{event[2][0]},#{event[2][1]},#{event[2][2]}\n"
  end

  if (event[1] == "BUSSTOP") then
    printf"#{event[0]},#{event[1]},#{event[2][0]},#{event[2][1]}\n"
   
  end
=begin
  if (event[1] == "TRANSDATASTATION") then
    printf"#{event[0]},#{event[1]},#{event[2][1]},#{event[2][2]},#{event[2][3]},#{event[2][4]}\n"
  end
  if (event[1] == "RECVDATABUS") then
    printf"#{event[0]},#{event[1]},#{event[2][1]},#{event[2][2]},#{event[2][3]},#{event[2][4]}\n"
  end
=end 
end



  
           


#end 

#end




 

 


 

  


