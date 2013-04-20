#!/usr/bin/ruby

opts = Struct.new( :name, :age, :switch, :option, :files ).new__goto__

### start-configuration-part ###
opts.name = 'unknown'
opts.age = 10
opts.switch = false
opts.option = 'opt0'
### end-configuration-part ###

require 'optparse' # http://ruby-doc.org/stdlib-1.8.7/libdoc/optparse/rdoc/OptionParser.html

program = $0[/[^\/]*$/]
author = '__user__'
Version = '0.01'

ARGV.options do |o|
  o.separator ""
  o.banner = "Syntax: #{program} [options] [file ...]"
  o.separator ""
  o.separator "    Description ..."
  o.separator ""
  o.separator "    Options:"
  o.separator ""

  o.on( '-n', '--name name', 'Parameter description' ) do |p|
    opts.name = p
  end

  o.on( '-a', '--age age', Integer, 'Parameter description' ) do |p|
    opts.age = p
  end

  o.on( '-s', '--switch', 'Parameter description' ) do
    opts.switch = true
  end

  o.on( '-o', '--option opt1|opt2', [:opt1, :opt2], 'Parameter description', '(opt1, opt2)' ) do |p|
    opts.option = p
  end

  o.on( '-?', '--help', 'Help' ) do
    puts o
    exit
  end

  o.on_tail('-v', '--version', 'Show program version') do
    puts o.ver
    puts "Author #{author}"
    exit
  end
end

def exitError(message)
  STDERR.puts "E: #{message}"
  exit 1
end
def exitHelpError(message)
  puts ARGV.options.to_s
  exitError(message)
end
	
begin
  ARGV.parse!
  opts.files = ARGV
rescue => optparse
  exitHelpError(optparse.message)
end

# code
puts opts.name
puts opts.age
puts opts.switch
puts opts.option
puts "Other parameters: "+opts.files.join(' ')

