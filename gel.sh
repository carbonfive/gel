#!/usr/bin/env ruby

def execute_command(command)
  puts %Q{\n## Running "#{command}"\n}
  puts %x{#{command}}
  raise "Failed with error code #{$?.to_i}" if $?.to_i > 0
end

ENV['RAILS_ENV'] = 'test'

execute_command %Q{bundle --no-color}
execute_command %Q{rake db:reset}
execute_command %Q{rake spec}
