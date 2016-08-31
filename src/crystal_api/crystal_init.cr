class CrystalInit
  INITIALIZERS       = [] of Proc(Nil)

  def self.start
    if INITIALIZERS.size > 0
      puts("About to run #{INITIALIZERS.size} initializers")

      INITIALIZERS.each do |p|
        p.call
      end

      puts("Initializers executed")
    end

    Kemal.run
  end

  def self.start_spawned
    spawn do
      start
    end
  end

  def self.wait_for_ready
    while Kemal.config.server.nil?
      sleep 0.01
    end
  end

  def self.start_spawned_and_wait
    start_spawned
    wait_for_ready
  end

  def self.stop
    Kemal.config.handlers.clear
  	Kemal::RouteHandler::INSTANCE.tree = Radix::Tree(Kemal::Route).new
    Kemal.config.server.not_nil!.close
  end

  def self.reset
    INITIALIZERS.clear
  end
end
