#-- This script is used to activate PCA infuser test harnesses, connect the battery, and connect the AC.
#   This allows the user to run a command line instead of open tera term, select the port, select the
#   port speed, activate the infuser, connect the battery, and connect the AC.
require "pcaapi"        #-- API for object under test

ALLOWABLE_STATIONS = ["A", "B", "C", "D"] # If at a later date lower case becomes possible, remove the upcase statement below

def print_err errorMsg
   puts errorMsg
   puts $!
   puts $!.backtrace
end

def activateStations(station)
   begin
      pca = PcaApi.new(nil, nil, station)
      if (pca and (pca.test_harness_activate().eql?(true)))
         puts "Station #{station} was activated successfully"
      else
         puts "Station #{station} failed to activate"
      end
      pca.close
   rescue
      print_err ("Unable to activate station (#{station}). Have you verified the port
                  numbers in the configuration file for PCA?")
   end
end

if (ARGV.empty? == false)
   ARGV.each do |station|
      station.upcase
      if (ALLOWABLE_STATIONS.include?(station))
         activateStations(station)
      else
         puts "The station you tried to use (#{station}) is not allowable, please use one
               of the following: #{ALLOWABLE_STATIONS.join(", ")}. If using multiple,
               please seperate them with a space"
      end
   end
else
   puts "No arguments were given. The correct syntax is along the lines of
        'ActivateStations.rb A' or 'ActivateStations.rb B C'"
end