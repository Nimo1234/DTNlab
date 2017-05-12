# dummy code
#require './objects.rb'

class Bus
  
  
attr_accessor :path
D=100
BUS_SPEED=10 
	def initialize(id)
    
		# .... > id
		@path = Array.new
    @id=id
	end
  
  def create_BUSARRIVAL(time0,station_id,bus_id)# defining   bus movement model with parameterlist
  		# Creating Events
  		info = [station_id,bus_id]
  		event = [time0, "BUSARRIVAL", info] # [TIME, EVENT_TYPE, INFORMATION]
  		@events.push(event)
  	end
    
  	def create_BUSDEPART(time1,station_id,bus_id)# defining   bus movement model with parameterlist
  		# Creating Events
  		info = [station_id,bus_id]
  		event = [time1, "BUSDEPART", info] # [TIME, EVENT_TYPE, INFORMATION]
  		@events.push(event)
  	end
    
  	def sort()
  		@events = @events.sort do |a,b| a[0] <=> b[0] end
  	end

  	def print()
  		@events.each do |event|
  			p event
  		end
  	end

	# [["PATH", "A", "B", 20], ...
	# @path = [ Bus Action, action, action, ....]
	# Path = [ActionType, StationId1, StationId2, minutes]
	# Stop = [ActionType, StationId1, minutes]

	def add_path(station_id1, station_id2, minutes)
		action = ["MOVE", station_id1, station_id2, minutes]
		@path.push(action)
	end

	def add_stop(station_id, minutes)
		action = ["STOP", station_id, minutes]
		@path.push(action)
	end

	def print_path()
		@path.each do |path|
			p path
		end

	end

	def print_path_event()
    
    current=0
    #stopping time=5
		@path.each do |path|
      #p path[0]
      # bus-001 arrival and stopping  time at station A 
      #p current  
      #p path  
      if (path[0]=='STOP') then        
        printf("%d %s STOP at %s\n", current, @id, path[1])
        current=path[2]+current
   
      end

      if(path[0]=='MOVE') then
        printf("%d %s DEPARTURE from %s to %s\n", current,@id,path[1],path[2])
        current=path[3]+current
        printf("%d %s ARRIVED from %s to %s\n", current,@id,path[1],path[2])
        #current=path[3]+current
        
      
#
      end 
      
      
		end
  end

	def print_path_event2()
    @arrival_event=[]
    @departur_event=[]
    # bus1 Arrival and departure calculation methods
    time = 0.0
    #path=[0,]+["A","arr","arrived"]
    #path.collect do |i|
      #p i
      #end
    path.collect{|path|}
    path[0]
    path[1]
    p path
    puts"   "
    eventlist =Array.new
    eventlist=[]
    
    
    #print""
  
		@path.each do |path|
    #@path[1][2]
  	#elements.each do |i| 
    p path
 


      
		end

	end
end



#NUM_STATIONS=4
#NUM_BUSES=2
#list_stations = Array.new
#list_buses=Arrayobject.new
#k=0
#for i in 0..(NUM_BUSES-1) do
#  bus_id = sprintf("station-%03d", i)
#  station.Station(station_id)


bus1 = Bus.new("bus1")
bus2 = Bus.new("bus2")

# Initialize of Bus movement
bus1.add_stop("A", 5)
bus1.add_path("A", "B", 20)
bus1.add_stop("B", 10)
bus1.add_path("B", "C", 15)
bus1.add_stop("C", 60)

bus1.print_path_event()


# bus2 movment model
bus2.add_stop("A", 15)
bus2.add_path("A", "B", 30)
bus2.add_stop("B", 20)
bus2.add_path("B", "C", 25)
bus2.add_stop("C", 80)

bus2.print_path_event()









#
# A(5min) -(20min) -> B (10min) -(15min)-> C (60min)
#
#
exit

#
# time BusId StationId ARR/DEP
# 0 Bus1 A arr
# 5 Bus1 A dep
# 25 Bus1 B arr
# 35 Bus1 B dep
# 50 Bus1 C arr
# 110 Bus1 C dep
# 


