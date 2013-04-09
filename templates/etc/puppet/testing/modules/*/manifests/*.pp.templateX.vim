let b:templateX.puppet_class = fnamemodify(b:templateX.dirname,':h:t')
if b:templateX.basename != 'init.pp'
	let b:templateX.puppet_subclass = b:templateX.file_without_extension
endif
