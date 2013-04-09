" Date/time values
let b:templateX.day        = strftime("%d")
let b:templateX.year       = strftime("%Y")
let b:templateX.month      = strftime("%m")
let b:templateX.time       = strftime("%H:%M")
let b:templateX.hostname   = hostname()
let b:templateX.domainname = system('dnsdomainname')
let b:templateX.user       = $SUDO_USER == '' ? $USER : $SUDO_USER

