" .../modules/class(-2)/manifests(-1) init.pp
" .../modules/class(-2)/manifests(-1) subclass.pp
" .../modules/class(-3)/manifests(-2)/subclass(-1) init.pp
" .../modules/class/-3)/manifests(-2)/subclass(-1) subsubclass.pp
" puppet apply --noop --verbose \
"   --modulepath /etc/puppet/modules " $PWD/../tests/init.pp
let words = split(b:templateX.dirname,'/')
if words[-2] == 'manifests' " subclass folder
	let b:templateX.puppet_class = words[-3]
	let b:templateX.puppet_subclass = words[-1]
	let b:templateX.puppet_fqcn = b:templateX.puppet_class . '::' . b:templateX.puppet_subclass
	if b:templateX.basename != 'init.pp'
		let b:templateX.puppet_subsubclass = b:templateX.file_without_extension
		let b:templateX.puppet_fqcn .= '::' . b:templateX.puppet_subsubclass
	endif
else " class folder
	let b:templateX.puppet_class = words[-2]
	let b:templateX.puppet_fqcn = b:templateX.puppet_class
	if b:templateX.basename != 'init.pp'
		let b:templateX.puppet_subclass = b:templateX.file_without_extension
		let b:templateX.puppet_fqcn .= '::' . b:templateX.puppet_subclass
	endif
endif
