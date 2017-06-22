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
         
          plot.output 'nemomsa.png'
          #plot.ylabel 'ylabel'
          #plot.yrange "[0:100]"
          plot.ylabel "% of total"
          plot.xlabel 'xlabel'
          plot.yrange "[0:10]"
         # plot.xrange "[0:20000]"
          plot.notitle " "
          plot.xlabel "Total number of Delivered Data"
          plot.ylabel " Replicated data"
          #plot.style  " "
          plot.data << Gnuplot::DataSet.new(data) do |ds|
            ds.with = 'linespoints'
            ds.notitle
            ds.with ='points'
          end
        end
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