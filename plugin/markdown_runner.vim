command! VikiRunEcho call markdown_runner#Echo()
command! VikiRunInsert call markdown_runner#Insert()
command! VikiRunQf call viki_run#Qf()
command! VikiRunLo call viki_run#Lo()

" if !exists("g:markdown_runners")
if !exists("g:vikirun_kernels")
    let g:vikirun_kernels = {
                \ '': getenv('SHELL'),
                \ 'go': function("markdown_runner#RunGoBlock"),
                \ 'js': 'node',
                \ 'javascript': 'node',
                \ 'vim': function("markdown_runner#RunVimBlock"),
                \ }
endif

" if !exists("g:markdown_runner_populate_location_list")
"     let g:markdown_runner_populate_location_list = 0
" endif
