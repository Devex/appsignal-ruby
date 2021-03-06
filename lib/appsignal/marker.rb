module Appsignal
  class Marker
    attr_reader :marker_data, :config
    ACTION = 'markers'

    def initialize(marker_data, config)
      @marker_data = marker_data
      @config = config
    end

    def transmit
      transmitter = Transmitter.new(ACTION, config)
      puts "Notifying AppSignal of deploy with: "\
        "revision: #{marker_data[:revision]}, user: #{marker_data[:user]}"

      result = transmitter.transmit(marker_data)
      if result == '200'
        puts 'AppSignal has been notified of this deploy!'
      else
        raise "#{result} at #{transmitter.uri}"
      end
    rescue => e
      puts "Something went wrong while trying to notify AppSignal: #{e}"
    end
  end
end
