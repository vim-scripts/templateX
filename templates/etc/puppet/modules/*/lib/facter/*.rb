Facter.add("__puppet_fact__") do
  setcode do
    Facter::Util::Resolution.exec('/bin/uname -i') # example__goto__
  end
end

