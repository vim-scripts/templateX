"
" A template system for Vim
"
" Copyright (C) 2013 Michael Arlt
"
" Distributed under the GNU General Public License (GPL) 3.0 or higher
" - see http://www.gnu.org/licenses/gpl.html
" Parts are based on work from Adrian Perez de Castro
"

if exists("g:templateX_plugin_loaded")
	finish
endif
let g:templateX_plugin_loaded = 1

" Put template system autocommands in their own group.
if !exists('g:templateX_no_autocmd')
	let g:templateX_no_autocmd = 0
endif
if !g:templateX_no_autocmd
	augroup Templating
		autocmd!
		autocmd BufNewFile * call <SID>TMain()
	augroup END
endif

" determines the path of the templates
if exists('g:templateX_templates')
	let s:templates = g:templateX_templates
else
	let s:templates = expand("<sfile>:p:h:h") . "/templates"
endif

function <SID>TMain()
	let template = <SID>TLoadIncludesAndReturnTemplate(s:templates,'%')
	if template == ''
		call <SID>TNotice('templateX no template found')
	elseif filereadable(template)
		execute "0r " . substitute(template,'*','\\*','g')
		call <SID>TExpandVars()
		redraw
		call <SID>TNotice('templateX used: ' . template)
		setlocal nomodified
	else
		call <SID>TError('templateX missing rights: ' . template)
	endif
endfunction

" convert facts to templateX variables
function <SID>TFact2templateXvar(line)
	let key = substitute(a:line,' .*', '', '')
	let val = substitute(a:line,'[^ ]* => ', '', '')
	execute 'let b:templateX.' . key . ' = val'
endfunction

" load facts using facter (live) or from a file
function <SID>TLoadFacts()
	if exists("g:templateX_facts")
		if g:templateX_facts == 'live'
			call <SID>TInfo('templateX including live facts')
			for line in split(system('facter'), "\x0a")
				call <SID>TFact2templateXvar(line)
			endfor
		elseif filereadable(g:templateX_facts)
			call <SID>TInfo('templateX including facts: ' . g:templateX_facts)
			for line in readfile(g:templateX_facts)
				call <SID>TFact2templateXvar(line)
			endfor
		else
		  call <SID>TError('templateX missing/access: ' . g:templateX_facts)
		endif
	endif
endfunction

function <SID>TLoadIncludesAndReturnTemplate(templates,path)
	let b:templateX = {} " dictionary used for substituition
	let b:templateXlog = [] " stores logging information

	let templates = a:templates
	let path = expand(a:path,':p')
	let path = fnamemodify(path,':p') " absolute
	let folder = fnamemodify(path,':h:t')
	let basename = fnamemodify(path,':t')
	if match(basename,'%') > -1
		let path = substitute('%' . basename, '%', '/','g')
	  let path = fnamemodify(path,':p') " absolute
	  let folder = fnamemodify(path,':h:t')
	  let basename = fnamemodify(path,':t')
		call <SID>TInfo('templateX found % - using filename: ' . path)
  endif
	let file_without_extension = fnamemodify(basename,':r')
	let extension = fnamemodify(basename,':e')
	let foundDir = ''
	let b:templateX.basename = basename
	let b:templateX.path = path
	let b:templateX.file_without_extension = file_without_extension
	let b:templateX.extension = extension
	let b:templateX.dirname = fnamemodify(path,':h')

	" traverse to the deepest possible path which matches you file path
	" e.g. vi /etc/hosts will walk to templateX/templates/etc
	for dir in split(path,'/')
		if isdirectory(templates . foundDir . '/' . dir)
			let foundDir .= '/' . dir
		else
			if isdirectory(templates . foundDir . '/*')
				let foundDir .= '/*'
			else
				break
			endif
		endif
		call <SID>TInfo('templateX going deeper: ' . templates . foundDir)
	endfor

	" search for exact filename, *.extension or *
	" and for the variants
	" if required: go back until successful
	let templatePath = templates . foundDir
	let template = ''
	let searchtemplate = 1
	while 1
		if searchtemplate
			for i in [basename, '*.' . extension, '*']
				let file = templatePath . '/' . i

				" show inputlist if variants of templates exist (files with ',...')
	      let options = []
				let x = 0
				for option in split(glob(substitute(file,'*','\\*','g').',*'),'\n')
					let x += 1
				  let option = substitute(option,'.*,',x.' ','g')
				  call add(options,option)
				endfor
				if len(options)
					call insert(options,'Select template variant:')
				  let option = inputlist(options)
				  if option > 0 && option < len(options)
				    let file .= ',' . substitute(options[option],'[0-9]* ','','')
				  endif
				endif

				call <SID>TInfo('templateX searching for: ' . file)
				if filereadable(file)
					let template = file
					let searchtemplate = 0
					call <SID>TLoadFacts()
					break
				endif
			endfor
		endif

		if !searchtemplate " -> template was found: search includes
			for i in [basename,'*.' . extension,'*']
				let file = templatePath . '/' . i . '.templateX.vim'
				call <SID>TInfo('templateX searching for: ' . file)
				if filereadable(file)
					call <SID>TInfo('templateX including: ' . file)
					let file = substitute(file,'*','\\*','g')
					execute 'source ' . file
				endif
			endfor
		endif

		if templatePath == templates
			break
		endif
		let templatePath = fnamemodify(templatePath,':h')
	endwhile

	return template
endfunction

" Performs variable expansion in a template once it was loaded
function <SID>TExpandVars()
	for key in sort(keys(b:templateX))
		let pre  = exists("g:templateX_pre")  ? g:templateX_pre  : '__'
		let post = exists("g:templateX_post") ? g:templateX_post : '__'
		silent! execute '%s/' . pre . key . post . '/' . b:templateX[key] . '/gI'
	endfor
	" goto mark
	silent! execute '%s/' . pre . 'goto' . post . '//gI'
endfunction

" all message functions
function <SID>TMessage(severity, message)
	call add(b:templateXlog,'[' . a:severity . '] ' . a:message)
endfunction

function <SID>TInfo(message)
	call <SID>TMessage('info', a:message)
endfunction

function <SID>TNotice(message)
	call <SID>TMessage('notice',a:message)
	echom a:message
endfunction

function <SID>TError(message)
	call <SID>TMessage('error',a:message)
	echoe a:message
endfunction

" Show collected log messages
function <SID>TShowLog()
	if exists("b:templateX")
		for logLine in b:templateXlog
			echo logLine
		endfor
	else
		echo 'templateX was not used in this buffer'
	endif
endfunction

" show all existing variables which are available for use in templates
function <SID>TShowVars()
	if exists("b:templateX")
		echo 'The folling variables are available:'
		for key in sort(keys(b:templateX))
			echo 'templateX b:templateX.' . key . '=' . b:templateX[key]
		endfor
	else
		echo 'All variables begin with "b:templateX."'
		echo 'Default variables:'
		echo '  basename dirname extension file_without_extension path'
		echo 'Additional variables may be (delivered with templates folder):'
		echo '  day domainname hostname month time user year'
		echo 'Other variables base on your configuration.'
		echo 'templateX was not used in this buffer -'
		echo 'to see which variables are available for a specific file: vi file.ext'
		echo 'and use :TemplateXvars again.'
	endif
endfunction

" Create direct commands in Vim to call the functions above
command -nargs=0 TemplateXvars call <SID>TShowVars()
command -nargs=0 TemplateXlog call <SID>TShowLog()

