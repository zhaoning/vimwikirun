command! VikiRunEcho call vikirun#Echo()
command! VikiRunInsert call vikirun#Insert()
command! VikiRunQf call vikirun#Qf()
command! VikiRunLo call vikirun#Lo()

" if !exists("g:markdown_runners")
if !exists("g:vikirun_kernels")
    let g:vikirun_kernels = {
                \ '': getenv('SHELL'),
                \ 'go': function("vikirun#RunGoBlock"),
                \ 'js': 'node',
                \ 'javascript': 'node',
                \ 'vim': function("vikirun#RunVimBlock"),
                \ }
endif

" if !exists("g:markdown_runner_populate_location_list")
"     let g:markdown_runner_populate_location_list = 0
" endif
