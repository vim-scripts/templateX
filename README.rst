=================================
 A Vim template plugin: templateX
=================================
:Author: Michael Arlt
:Version: 1.0

Distributed under the ``GNU General Public License (GPL) 3.0`` or higher
- see file ``COPYING`` and http://www.gnu.org/licenses/gpl.html

Small parts of templateX are based on work from ``Adrian Perez de Castro``.

This is a plugin for Vim that will allow you to have a set of
templates for certain file types. It is useful for automating
some daily tasks with custom includes which enable you to
extend the functionality of templateX.


Installation
============

The easiest way to install the plugin is to install it as a bundle:

1. Get and install `pathogen.vim`__. You can skip this step if you
   already have it installed.

2. ``cd ~/.vim/bundle`` # if you use pathogen

3. Unpack templateX plugin

4. Optional: Copy the template directory to another location.
   Useful if you want to maintain the templates system wide or
   want to have a smarter update process (no impact to your templates).
   Adjust ``g:templateX_templates`` to the new templates directory::

   let g:templateX_templates = '/usr/local/vim-templates' " in ~/.vimrc


__ https://github.com/tpope/vim-pathogen


Configuration
=============

In your ``.vimrc`` you can put:

* ``let g:templateX_plugin_loaded = 1`` any value: skip loading this plugin
* ``let g:templateX_no_autocmd = 1`` disable templates for new files
* ``let g:templateX_templates = path`` overwrite the default template path
* ``let g:templateX_facts = 'live' | path`` set fact source
* ``let g:templateX_pre = '${'`` (def.: __) define markup of template vars
* ``let g:templateX_post = '}'`` (def.: __) e.g. ${user} in this example

Examine and customize the ``templates`` folder.
Be aware that the templates are only examples and not fully tested -
especially all templates in the deeper directories (e.g. puppet/icinga).


Updating
========

In order to update the plugin, go to its directory and replace its
content with a new version.

If you want to modify the ``templates`` folder (you want!):

    It seems to be a good way to copy the whole template folder to a
    location outside of the plugin. Your changes keep unaffected during
    updates.
    Remember to set a the global variable ``g:templateX_templates``.


Usage
=====

Create a new file giving it a name. The suffix will be used to determine
which template to use - e.g.::

    $ vim foo.sh
    :w " to save; be aware that :x only saves if you modified the buffer


Template search order
---------------------

The algorithm to search for templates works like this:

1. Starting from ``g:templateX_templates`` - goes as deep as possible
   into the folder structure if it matches the path of your filename.
   e.g. ``vi`` ``/etc/vim/vimrc.local`` -> searches in ``templates/etc/vim``

2. Searches for a template which matches the filename
   e.g. ``templates/etc/vim/vimrc.local``

3. If not found: Searches for a template with same extension
   e.g. ``templates/etc/vim/\*.local``

3. If not found: Searches for a template with filename '*'
   e.g. ``templates/etc/vim/\*``

4. If not found: Walks back in directory structure
   e.g. ``templates/etc``

5. Goto *(2)*

Stops if it reaches the template entry directory and no template was found.

If a template was found it gets loaded and the search for
``.vim`` files starts - see next chapter.


Variables in templates
----------------------

Variables are used to fill the template in Vim with appropriate
information.

Starting from the directory where the template was found:

1. The facts get sourced if ``g:templateX_facts`` is set

2. Searches for a ``.templateX.vim`` file which matches the filename
   e.g. ``vimrc.local.templateX.vim``

3. If not found: Searches for a template with same extension
   e.g. ``\*.templateX.vim``

4. If not found: Searches for a template with filename ``*``
   e.g. ``\*.vim``

5. Walks back one level in the directory structure until the template
   entry folder is reached.

6. Goto *(2)*

All ``.templateX.vim`` files are sourced - so you have a flexible solution to
define your own variables.

Have a look at the other templates files and directories, too.
Remove or change them according to your needs.

Examples for variable substitution:

Let us assume that your account is ``peter``.
With default values for ``g:templateX_pre`` and ``..._post``

A template containing::

    # Author: __user

Will result in::

    # Author: peter

If you use the following setting::

    :let g:templateX_pre = '${'
    :let g:templateX_post = '}'

You can use::

    # Author: ${user}


Available variables
-------------------

Use the command ``:TemplateXvars`` to display all available variables.
This function is available if ``templateX`` found a template and loaded it.
If you want to have more variables: See chapter "``facter``".

Example::

    vi foo.sh " template must exist - file must not exist
    :TemplateXvars

Output::

    The folling variables are available:
    templateX b:templateX.basename=foo.sh
    templateX b:templateX.day=25
    templateX b:templateX.dirname=/home/michael
    templateX b:templateX.extension=sh
    templateX b:templateX.fileWithoutExtension=foo
    templateX b:templateX.hostname=rocket76
    templateX b:templateX.month=03
    templateX b:templateX.path=/home/michael/foo.sh
    templateX b:templateX.time=06:58
    templateX b:templateX.user=michael
    templateX b:templateX.year=2013

Example usage in include files (``*.templateX.vim``)::

    let b:templateX.yearmonth = b:templateX.year . '/' . b:templateX.month

Example usage in templates::

    #!/bin/bash
    # Created: __yearmonth__

Special ``goto``

    Expands to nothing, but ensures that the cursor will be placed in its
    position after expanding the template.::

    echo "Hello"__goto__


templateX logging
-----------------

To display internal operation::

    :TemplateXlog

This function is available if ``templateX`` tried to find a template::

    user@server:~$ vi test.sh # 1st time templateX gets used
    :e test2.sh " 2nd time


facter
------

The tool ``facter`` from ``Luke Kanies`` can provide facts of your environment.

On my Ubuntu 12.04::

    user@server:~$ facter

    architecture => amd64
    facterversion => 1.6.5
    hardwareisa => x86_64
    hardwaremodel => x86_64
    hostname => rocket76
    id => michael
    interfaces => lo
    ipaddress => 127.0.1.1
    ipaddress_lo => 127.0.0.1
    is_virtual => false
    kernel => Linux
    kernelmajversion => 3.2
    kernelrelease => 3.2.0-39-generic
    kernelversion => 3.2.0
    lsbdistcodename => precise
    lsbdistdescription => Ubuntu 12.04.2 LTS
    lsbdistid => Ubuntu
    lsbdistrelease => 12.04
    lsbmajdistrelease => 12
    memoryfree => 1.75 GB
    memorysize => 3.54 GB
    memorytotal => 3.54 GB
    netmask_lo => 255.0.0.0
    network_lo => 127.0.0.0
    operatingsystem => Ubuntu
    operatingsystemrelease => 12.04
    osfamily => Debian
    path => /home/user/bin:/usr/local/sbin:/usr/local/bin:...
    physicalprocessorcount => 1
    processor0 => Intel(R) Core(TM) i3 CPU       U 380  @ 1.33GHz
    processor1 => Intel(R) Core(TM) i3 CPU       U 380  @ 1.33GHz
    processor2 => Intel(R) Core(TM) i3 CPU       U 380  @ 1.33GHz
    processor3 => Intel(R) Core(TM) i3 CPU       U 380  @ 1.33GHz
    processorcount => 4
    ps => ps -ef
    rubysitedir => /usr/local/lib/site_ruby/1.8
    rubyversion => 1.8.7
    selinux => false
    swapfree => 3.65 GB
    swapsize => 3.68 GB
    timezone => CEST
    uniqueid => ...
    uptime => 16 days
    uptime_days => 16
    uptime_hours => 390
    uptime_seconds => 1405283
    virtual => physical

These facts are available if you set ``g:templateX_facts``::

    user@server:~$ vi ~/.vimrc # and insert the following line:
    let g:templateX_facts = 'live'

Live facts cost some time - 2 seconds on my laptop.
Alternatively you can set it to a file which must contain the facter output::

    user@server:~$ facter >/usr/local/share/facts
    user@server:~$ vi ~/.vimrc # and insert the following line:
    let g:templateX_facts = '/usr/local/share/facts' " e.g. in your .vimrc

Consider updating the facts-file regulary (e.g. cron).

