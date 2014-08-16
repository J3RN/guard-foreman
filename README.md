# Guard::Foreman

`Guard::Foreman` automatically restarts Foreman using [Guard] [gu].

[gu]: https://github.com/guard/guard


## Installation

**NOTE**: Guard::Foreman is not yet finished! In fact, it's hardly begun. I'll
update here when I have finished it.

<!--Using Rubygems:-->

<!-- $ gem install guard-foreman -->

<!--Using Bundler, add this to your `Gemfile`, preferably in the `development` group:-->

```ruby
group :development
  gem 'guard-foreman'
end
```

Add a sample Guard definition to your `Guardfile`:

    $ guard init foreman


## Guard General Usage

Please read the [guard usage doc] [gd] in order to find out more about Guard and
how to use Guards. There is also [a Railscast about Guard] [gc], created by Ryan
Bates.


[gd]: https://github.com/guard/guard/blob/master/README.md
[gc]: http://railscasts.com/episodes/264-guard

It is recommended that you also install the [ruby-gntp] [gntp] on Mac OS X,
[libnotify] [ln] on Linux, FreeBSD or Solaris or [rb-notifu] [notifu] in order
to have graphical notifications.

[gntp]: https://rubygems.org/gems/ruby_gntp
[ln]: https://rubygems.org/gems/libnotify
[notifu]: https://rubygems.org/gems/rb-notifu


## Guardfile for guard-foreman

```ruby
guard :foreman, profile: 'Profile.dev'
```

Available options (Note: mostly stolen directly from the [Foreman documentation]
 [fd]):

[fd]: http://ddollar.github.io/foreman/

* `:log_file` Specify a location to pipe the Foreman logs into. Defaults to
  `log/foreman.log`
* `:concurrency` Specify the number of each process to run. This should be
  passed in the format `process=num,process=num`
* `:env` Specify one or more .env files to load
* `:procfile` Specify an alternate Procfile to load
* `:port` Specify which port to use as the base for this application. Should be
  a multiple of 1000.
* `:root` Specify an alternate application root. This defaults to the directory
  containing the Procfile.

NOTE: The parent project of Guard::Foreman, [Guard::Unicorn] [gdu], has a
`:bundler` option available for using `bundle exec`. I have removed this bit of
functionality as the [Foreman Github page] [fgp] asks users to *not* put
Foreman in their Gemfiles.

[gdu]: https://github.com/andreimaxim/guard-unicorn
[fgp]: https://github.com/ddollar/foreman
