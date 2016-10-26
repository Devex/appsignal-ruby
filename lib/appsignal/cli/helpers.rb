module Appsignal
  class CLI
    module Helpers
      private

      def colorize(text, color)
        return text if Gem.win_platform?

        color_code =
          case color
          when :red then 31
          when :green then 32
          when :yellow then 33
          when :blue then 34
          when :pink then 35
          else 0
          end

        "\e[#{color_code}m#{text}\e[0m"
      end

      def periods
        3.times do
          print "."
          sleep 0.5
        end
      end

      def press_any_key
        puts
        print "  Ready? Press any key:"
        stdin.getch
        puts
        puts
      end

      def ask_for_input
        value = stdin.gets
        value ? value.chomp : ""
      end

      def required_input(prompt)
        loop do
          print prompt
          value = ask_for_input
          return value if value.length > 0
        end
      end

      def yes_or_no(prompt)
        loop do
          print prompt
          case ask_for_input
          when "y"
            return true
          when "n"
            return false
          end
        end
      end

      def stdin
        $stdin
      end
    end
  end
end
