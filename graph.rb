#require 'Gnuplot'
require 'gnuplot'
require 'csv'
require 'open3'

data=Hash.new 
while (line = STDIN.gets) do
  event= line.strip.split(" ")
 
  #p event
  total_succeded = 0
  if (event[1]=="SUCCESS")
      #puts event[1]
      #puts event[0]
      printf("%s,%s,%s,%s,%s,%s\n",event[0], event[1], event[2],event[3],event[4],event[5])
      #printf("%s,%s,%s\n",event[0],event[4],event[5])
    
    end 
  end

class DataPlotter
  class << self
    def plot_data(data)
      Gnuplot.open do |gp|
        Gnuplot::Plot.new(gp) do |plot|
          plot.title  'test'
          plot.terminal 'png'
          #plot.output 'nemo3.png'
        
          plot.terminal 'png'
          plot.grid
          plot.output 'nemomsa.png'
          #plot.ylabel 'ylabel'
          #plot.yrange "[0:100]"
          plot.ylabel "% of total"
          
  
          #plot.xlabel 'xlabel'
          #plot.xrange "[0:20000]"
          plot.notitle " "
          plot.xlabel "Total number of Delivered Data"
          plot.ylabel "Replicated data"
          plot.set "linestyle 1 linecolor rgbcolor 'blue' linetype 1"
          plot.style "fill solid border -1"
          plot.xtics "rotate by -45"
          
          x1=2
          plot.arrow "from first %f,graph 0 rto first 0,graph 1 nohead lw 2 lt 0 lc 3" % x1
          #plot.set "dgrid3d 50,50"
          #plot.set "hidden3d"
          plot.yrange "[0:10]"
          #plot.autoscale 
          #plot.size i_size
          
          
          #x = (0..50).collect { |v| v.to_f }
          #y = x.collect { |v| v ** 2 }
          #plot.style  " "
          plot.data << Gnuplot::DataSet.new(data) do |ds|
            ds.with = 'linespoints'
            ds.with ='linespoints'
            ds.with = "lines"
            ds.with = "lines ls 1"
            ds.title = "Data Replication"
            ds.linewidth =4
            ds.linecolor = 'rgb "red"'
            ds.linewidth = 4
            
            ds.with = "linespoints"
            ds.linecolor = 'rgb "purple"'
            ds.linewidth = 3 
            #ds.with = "boxes"
            #ds.title = "step = #{@step}
            #ds.with = 'lines lc rgb "blue"'
            
            #ds.using = "2:xtic(1)"
            #ds.with = 'boxes lc rgb "orange"'
            
            
           
            
          end
        end
       gets
      end
    end
    
    def load_data_from_file(filename)
      count =0 
      File.open(filename).readlines.map do |line|
        line.chomp.to_f
        count+=1
        #p count
      end
    end

    def plot_file(filename)
      plot_data(load_data_from_file(filename))
    end
  end
  
end
DataPlotter.plot_file('nimo.csv')