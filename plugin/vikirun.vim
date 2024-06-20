command! VikiRunEcho call vikirun#Echo()
command! VikiRunInsert call vikirun#Insert(0)
command! VikiRunReplace call vikirun#Insert(1)
command! VikiRunQf call vikirun#Qf()
command! VikiRunLo call vikirun#Lo()

if !exists("g:vikirun_kernels")
    let g:vikirun_kernels = {
                \ '': getenv('SHELL'),
                \ 'go': function("vikirun#RunGoBlock"),
                \ 'js': 'node',
                \ 'javascript': 'node',
                \ 'vim': function("vikirun#RunVimBlock"),
                \ }
endif

