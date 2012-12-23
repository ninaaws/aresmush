module AresMUSH
  module Login
    class Quit
      include AresMUSH::Plugin

      def want_command?(cmd)
        is_quit_command?(cmd)
      end
      
      def want_anon_command?(cmd)
        is_quit_command?(cmd)
      end
      
      def is_quit_command?(cmd)
        cmd.root_is?("quit")
      end
            
      def on_command(client, cmd)
        client.disconnect
      end
    end
  end
end
