
require './objects.rb'
#require 'csv' 


#Mean Arrival Time = 5 minutes = 5/60th hours
#Mean Arrival Rate = 60/5 = 12 customers per hour
#inter_arrival_time = 8/10 # If 10  buses arrive at station  every 8 hours, the time between each arrival is;

def calc_interval(number_events)
	prng = 60.00/number_events # temporal solution, IMPROVE

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
		info = [data_id, data_size, sensor_id, station_id]
		event = [time0, "TRANSDATA", info] # [TIME, EVENT_TYPE, INFORMATION]
		@events.push(event)
	end
  
	def create_RECVDATA(time1, data_id, sensor_id, data_size,station_id)
		# Creating Events
		info = [data_id, data_size, sensor_id, station_id]
		event = [time1, "RECVDATA", info] # [TIME, EVENT_TYPE, INFORMATION]
		@events.push(event)
	end
  
  # arrival and departure bus events
  
  def create_BUSARRIVAL(time,bus_id,stat_id)# defining   bus movement model with parameterlist
  		# Creating Events
  		info = [bus_id,stat_id]
  		event = [time,"BUSARRIVAL", info] # [TIME, EVENT_TYPE, INFORMATION]
  		@events.push(event)
  	end
  
  def create_BUSDEPART(time,bus_id,stati_id)# defining   bus movement model with parameterlist
    # Creating Events
  	info = [bus_id,stati_id]
  	event = [time,"BUSDEPART", info] # [TIME, EVENT_TYPE, INFORMATION]
  	@events.push(event)
  end 
  
  def create_BUSSTOP(time,bus_id,statio_id,stoptime) # defining   bus movement model with parameterlist
    # Creating Events
  	info = [bus_id,statio_id, stoptime]
  	event = [time,"BUSSTOP", info] # [TIME, EVENT_TYPE, INFORMATION]
  	@events.push(event)
  end 
  
  # create data transmisiion from station to bus 
  
	def create_TRANSDATASTATION(time0, data_id,bus_id,data_size, station_id)
		# Creating Events
		info = [data_id,bus_id, data_size, station_id]
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
def count_round_trip()
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
	  		prng = sensor.calc_interval()
	  		count_data += 1

			# Creating Events
			eventlist.create_GENDATA(time, data_id, sensor.id, data.size)

			time += prng.to_f
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
	time0 = event[0]+0.5 # time generated during the data generation 
	eventlist.create_TRANSDATA(time0, data_id, sensor_id, data_size, station_id)

#	time1 = time0+1
#	eventlist.create_RECVDATA(time1, data_id, sensor_id, data_size, station_id)
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
bus3 = Bus.new("bus-003")
bus4 = Bus.new("bus-004")
bus5 = Bus.new("bus-005")
car1 = Bus.new("car-001 ")
car2 = Bus.new("car-002")
#exit


#p list_stations


bus1.move("station-001", "station-002",120*60)# station_id 
bus1.stop("station-002",30*60)# station_id

bus1.move("station-002", "station-003",120*60)# station_id 
bus1.stop("station-003",30*60)# station_id

bus1.move("station-003", "station-004",120*60)# station_id 
bus1.stop("station-004",30*60)# station_id

bus1.move("station-004", "station-001",120*60)# station_id 
bus1.stop("station-001",30*60)# station_id

bus2.move("station-003","station-004",120*60)#
bus2.stop("station-004",30*60)

bus2.move("station-004","station-001",120*60)#
bus2.stop("station-001",30*60)

bus2.move("station-001","station-002",120*60)#
bus2.stop("station-002",30*60)

bus2.move("station-002","station-003",120*60)#
bus2.stop("station-003",30*60)


bus3.move("station-004","station-001",120*60)#
bus3.stop("station-001",30*60)

bus3.move("station-001","station-002",120*60)#
bus3.stop("station-002",30*60)

bus3.move("station-002","station-003",120*60)#
bus3.stop("station-003",30*60)

bus3.move("station-003","station-004",120*60)#
bus3.stop("station-004",30*60)

# add number of Buses 
bus4.move("station-001", "station-002",120*60)# station_id 
bus4.stop("station-002",30*60)# station_id

bus4.move("station-002", "station-003",120*60)# station_id 
bus4.stop("station-003",30*60)# station_id

bus4.move("station-003", "station-004",120*60)# station_id 
bus4.stop("station-004",30*60)# station_id

bus4.move("station-004", "station-001",120*60)# station_id 
bus4.stop("station-001",30*60)# station_id

bus5.move("station-003","station-004",120*60)#
bus5.stop("station-004",30*60)

bus5.move("station-004","station-001",120*60)#
bus5.stop("station-001",30*60)

bus5.move("station-001","station-002",120*60)#
bus5.stop("station-002",30*60)

bus5.move("station-002","station-003",120*60)#
bus5.stop("station-003",30*60)


car1.move("station-004","station-001",120*60)#
car1.stop("station-001",30*60)

car1.move("station-001","station-002",120*60)#
car1.stop("station-002",30*60)

car1.move("station-002","station-003",120*60)#
car1.stop("station-003",30*60)

car1.move("station-003","station-004",120*60)#
car1.stop("station-004",30*60)


car2.move("station-004","station-001",120*60)#
car2.stop("station-001",30*60)

car2.move("station-001","station-002",120*60)#
car2.stop("station-002",30*60)

car2.move("station-002","station-003",60*60)#
car2.stop("station-003",30*60)

car2.move("station-003","station-004",120*60)#
car2.stop("station-004",30*60)

#list_buses=[bus1,bus2]

bus1_path=bus1.get_path()
bus2_path=bus2.get_path()
bus3_path=bus3.get_path()
bus4_path=bus4.get_path()
bus5_path=bus5.get_path()
car1_path=car1.get_path()
car2_path=car2.get_path()



#p bus_path
eventlist.sort()
#eventlist.events.each do |event|
#  #p event
#end

[bus1_path, bus2_path,bus3_path,bus4_path,bus5_path,car1_path,car2_path].each do |bus_path|

  
  #puts "#{bus1_travel_cycle}"
  current=0
  bus_path.each do |path|
    count= 0 
    if (path[0]=='STOP') then
    	eventlist.create_BUSSTOP(current, path[1], path[2], path[3])
        current=path[3]+current
    end
   
    if(path[0]=='MOVE') then
      eventlist.create_BUSDEPART(current, path[1], path[2])

      current=path[4]+current
      eventlist.create_BUSARRIVAL(current, path[1], path[3])
     
      end 
    end 
  end 
   
  # Data transmission Event from station To bus within specific data size 
      

eventlist.sort()
eventlist.events.each do |event|
  printf("%s,%s,%s\n", event[0], event[1], event[2].join(","))
end

exit
