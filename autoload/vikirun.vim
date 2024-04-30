" Run code block and echo results
function! vikirun#Echo() abort
    try
        let runner = s:RunCodeBlock()
        echo runner.result
    catch /.*/
        call s:error(v:exception)
    endtry
endfunction

" Run code block and insert results into buffer
function! vikirun#Insert() abort
    try
        let runner = s:RunCodeBlock()
        let result_lines = split(runner.result, '\n')
        call append(runner.end, '')
        call append(runner.end + 1, '{{{')
        call append(runner.end + 2, result_lines)
        call append(runner.end + len(result_lines) + 2, '}}}')
    catch /.*/
        call s:error(v:exception)
    endtry
endfunction

" Run code block and direct results to quickfix
function! vikirun#Qf() abort
    try
        let runner = s:RunCodeBlock()
        cexpr runner.result
    catch /.*/
        call s:error(v:exception)
    endtry
endfunction

" Run code block and direct results to location list
function! vikirun#Lo() abort
    try
        let runner = s:RunCodeBlock()
        lexpr runner.result
    catch /.*/
        call s:error(v:exception)
    endtry
endfunction

" Handle errors
function! s:error(error)
    execute 'normal! \<Esc>'
    echohl ErrorMsg
    echo "VimwikiRun: " . a:error
    echohl None
endfunction

function! s:RunCodeBlock() abort
    let runner = s:ParseCodeBlock()
    let Runner = s:GetKernel(runner.language)
    if type(Runner) == v:t_func
        let result = Runner(runner.src)
    elseif type(Runner) == v:t_string
        let result = system(Runner, runner.src)
    else
        throw "Invalid kernel."
    endif
    let runner.result = result
    return runner
endfunction

function! s:ParseCodeBlock() abort
    let result = {}

    if match(getline("."), '^{{{') != -1
        throw "Not in a markdown code block."
    endif
    let start_i = search('^{{{', 'bnW')
    if start_i == 0
        throw "Not in a markdown code block."
    endif
    let end_i = search('^}}}', 'nW')
    if end_i == 0
        throw "Not in a markdown code block."
    endif
    let lines = getline(start_i, end_i)
    if len(lines) < 3
        throw "Code block is empty."
    endif

    let result.src = lines[1:-2]
    let result.language = lines[0][3:]
    let result.start = start_i
    let result.end = end_i
    let result.result = ''

    return result
endfunction

function! s:GetKernel(language) abort
    if exists('b:vikirun_kernels') && has_key(b:vikirun_kernels, a:language)
        return b:vikirun_kernels[a:language]
    endif
    return get(g:vikirun_kernels, a:language, a:language)
endfunction

function! vikirun#RunGoBlock(src) abort
    let tmp = tempname() . ".go"
    let src = a:src

    " wrap in main function if it isn't already
    let joined_src = join(src, "\n")
    if match(joined_src, "^func main") == -1
        let src = split("func main() {\n" . joined_src . "\n}", "\n")
    endif

    if match(src[0], "^package") == -1
        call insert(src, "package main", 0)
    endif

    call writefile(src, tmp)
    let src = systemlist("goimports " . tmp)
    call writefile(src, tmp)
    let res = system("go run " . tmp)
    call delete(tmp)
    return res
endfunction

function! vikirun#RunVimBlock(src) abort
    let tmp = tempname() . ".vim"
    call writefile(a:src, tmp)
    execute "source " . tmp
    call delete(tmp)
    return ""
endfunction
