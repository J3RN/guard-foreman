require 'guard'
require 'guard/guard'

module Guard
  class Foreman < Guard

    # Initialize a Guard.
    # @param [Array<Guard::Watcher>] watchers the Guard file watchers
    # @param [Hash] options the custom Guard options
    def initialize(watchers = [], options = {})
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

      cmd = []
      cmd << "foreman start"
      cmd << "-c #{@concurrency}" if @concurrency
      cmd << "-e #{@env}"         if @env
      cmd << "-f #{@procfile}"    if @profile
      cmd << "-p #{@port}"        if @port
      cmd << "-d #{@root}"        if @root


      @pid = ::Process.fork do
        system "#{cmd.join " "}"
      end

     success "Foreman started."
    end

    # Called when `stop|quit|exit|s|q|e + enter` is pressed (when Guard quits).
    # @raise [:task_has_failed] when stop has failed
    def stop
      begin
        ::Process.kill("QUIT", @pid) if ::Process.getpgid(@pid)

        # foreman won't always shut down right away, so we're waiting for
        # the getpgid method to raise an Errno::ESRCH that will tell us
        # the process is not longer active.
        sleep 1 while ::Process.getpgid(@pid)
        success "Foreman stopped."
      rescue Errno::ESRCH
        # Don't do anything, the process does not exist
      end
    end

    # Called when `reload|r|z + enter` is pressed.
    # This method should be mainly used for "reload" (really!) actions like
    # reloading passenger/spork/bundler/...
    # @raise [:task_has_failed] when reload has failed
    def reload
      # If the `preload_app` directive is false, then the workers will pick up
      # any code changes using a `HUP` signal, but if the application is
      # preloaded, then a `USR2 + QUIT` signal must be used.
      if @preloading
        oldpid = @pid
        UI.debug "Sending USR2 to Foreman with pid #{oldpid}"
        ::Process.kill 'USR2', oldpid
        UI.debug "Sending QUIT to Foreman with pid #{oldpid}"
        ::Process.kill 'QUIT', oldpid
      else
        ::Process.kill 'HUP', @pid
      end

      UI.info "Done reloading Foreman."
      success "Foreman reloaded"
    end

    # Called when just `enter` is pressed
    # This method should be principally used for long action like running all specs/tests/...
    # @raise [:task_has_failed] when run_all has failed
    def run_all
    end

    # Called on file(s) modifications that the Guard watches.
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    def run_on_modifications(paths)
      reload
    end

    private
    def info(msg)
      UI.info(msg)
    end

    def pending message
      notify message, :image => :pending
    end

    def success message
      notify message, :image => :success
    end

    def failed message
      notify message, :image => :failed
    end

    def notify(message, options = {})
      Notifier.notify(message, options)
    end
  end
end
