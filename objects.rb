

class Station
	attr_accessor :id,:bus_id

	def initialize(id)
		@id = id
		@list_sensors = Array.new # for sensors
	end

	def add_sensor(instance_sensor)
		@list_sensors.push(instance_sensor)
	end

	def get_sensors()
		return (@list_sensors)
	end

  def get_list_buses()
    @list_buses=list_buses
  	return (@list_buses)
  end
	
end


class Sensor
	class Data
		attr_accessor :size

		def initialize(id, origin_id)
			@id = id
			@origin_id = origin_id
		end

	end
	
	attr_accessor :id,:station_id
 
  
	@datatype # Short-Text(1Kbytes), Text(10Kbytes), Photo(1Mbytes), Video(10Mbytes)
	@datafreq # number of data generation in 1 mins

	def initialize(id, station_id, datatype="Short-Text", datafreq=1)
		@id = id
		@datatype = datatype
		@datafreq = datafreq
		@station_id = station_id
    
	end

	def create_data(data_id)
		data = Data.new(data_id, @id)
		if (@datatype == "Short-Text") then
			data.size = 1024 #bytes
		end
		if (@datatype == "Text") then
			data.size = 1024*10 #bytes
		end
		if (@datatype == "Photo") then
			data.size = 1024*1024 #bytes
		end
		if (@datatype == "Video") then
			data.size = 1024*1024*10 #bytes
		end

		if (data.size == nil) then
			raise # Raising error
		end

		return (data)
	end
  
  #def Monitar_record()
    

	def calc_interval()
#	    interval = 60.0/@datafreq # temporal solution, IMPROVE 
	    interval = rand(60)
		return (interval)
	end

end
#creating bus object 

class Bus
   attr_accessor :id,:path,:bus_id

  def initialize(id)
    @bus_id=id
    # for buses
    @path = Array.new
  end
  
  # add path for the bus 
	def move(station_id1, station_id2, minutes)
		action = ["MOVE", @bus_id, station_id1, station_id2, minutes]
		@path.push(action)
	end

	def stop(station_id,minutes)
		action = ["STOP", @bus_id, station_id,minutes]
		@path.push(action)
	end

    def get_path()
      return(@path)
    end

end

#bus1 = Bus.new("bus1")
#bus2 = Bus.new("bus2")

# Initialize of Bus movement
#bus1.add_stop("A", 5)
#bus1.add_path("A", "B", 20)
#bus1.add_stop("B", 10)
#bus1.add_path("B", "C", 15)
#bus2.add_stop("C", 60)
#bus2.add_stop("A", 5)
#bus2.add_path("A", "B", 20)
#bus2.add_stop("B", 10)
#bus2.add_path("B", "C", 15)
#bus2.add_stop("C", 60)

#bus1.print_path_event()

