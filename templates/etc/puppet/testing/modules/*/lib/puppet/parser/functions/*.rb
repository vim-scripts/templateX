module Puppet::Parser::Functions
  newfunction(:__puppet_function__, :type => :rvalue ) do |args|
    return $args[0]__goto__
  end
end

