let b:templateX.monitoringservername = b:templateX.file_without_extension
let b:templateX.monitoringip = substitute(system('LANG= host -t A ' . b:templateX.monitoringservername . '|cut -f4 -d" "'),"\n","","")
if b:templateX.monitoringip == "found:"
	let b:templateX.monitoringip = 'UNKNOWN!'
endif
