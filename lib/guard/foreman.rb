require 'guard'
require 'guard/plugin'
require 'spoon'

module Guard
  class Foreman < Plugin

    # Default log location (Rails in mind)
    DEFAULT_LOG_LOCATION = "log/foreman.log"
    TITLE = "Foreman status"

    # Initialize a Guard.
    # @param [Array<Guard::Watcher>] watchers the Guard file watchers
    # @param [Hash] options the custom Guard options
    def initialize(options = {})
      @log_file       = options.fetch(:log_file, DEFAULT_LOG_LOCATION)
      @concurrency    = options[:concurrency]
      @env            = options[:env]
      @procfile       = options[:procfile]
      @port           = options[:port]
      @root           = options[:root]

      super
    end

    # Call once when Guard starts. Please override initialize method to init stuff.
    # @raise [:task_has_failed] when start has failed
    def start
      # Stop if running
      stop if @pid

      cmd = "foreman start"
      cmd += " -c #{@concurrency}" if @concurrency
      cmd += " -e #{@env}"         if @env
      cmd += " -f #{@procfile}"    if @procfile
      cmd += " -p #{@port}"        if @port
      cmd += " -d #{@root}"        if @root
      #cmd += " > #{@log_file}"     # Disabled for now

      debug "About to run #{cmd}"
      @pid = ::Spoon.spawnp(*cmd.split(" "))     # Spoon is a little weird

     info "Foreman started."
     debug "Foreman has pid #{@pid}"
     success "Foreman started"
    end

    # Called when `stop|quit|exit|s|q|e + enter` is pressed (when Guard quits).
    # @raise [:task_has_failed] when stop has failed
    def stop
      if @pid
        begin
          debug "Asking Foreman to terminate... (#{@pid})"
          ::Process.kill("TERM", @pid)
          debug "Waiting for Foreman to stop..."
          ::Process.waitpid(@pid)
          @pid = nil          # Unset @pid
        rescue Errno::ESRCH
          # Don't do anything, the process does not exist
          debug "Could not find Foreman process"
        end
        info "Foreman stopped."
      end
    end

    # Called when `reload|r|z + enter` is pressed.
    # This method should be mainly used for "reload" (really!) actions like
    # reloading passenger/spork/bundler/...
    # @raise [:task_has_failed] when reload has failed
    def reload
      info "Restarting Foreman..."
      stop
      start
    end

    # Called when just `enter` is pressed
    # This method should be principally used for long action like running all specs/tests/...
    # @raise [:task_has_failed] when run_all has failed
    def run_all
      start
    end

    # Called on file(s) modifications that the Guard watches.
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    def run_on_changes(paths)
      reload
    end

    def run_on_additions(paths)
      reload
    end

    def run_on_modifications(paths)
      reload
    end

    def run_on_removals(paths)
      reload
    end

    private

    def info(msg)
      UI.info(msg)
    end

    def debug(msg)
      UI.debug(msg)
    end

    def success(msg)
      ::Guard::Notifier.notify(msg, title: TITLE, image: :success)
    end

    def failure(msg)
      ::Guard::Notifier.notify(msg, title: TITLE, image: :failure)
    end
  end
end
