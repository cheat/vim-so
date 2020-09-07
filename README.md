vim-so
======
`vim-so` wraps the [so][] executable to provide a plain-language search interface
for code snippets on Stack Overflow.


Example
-------
Assume that you're building a Go application, and have forgotten how to
reverse an array. You may run the following ex command:

  `:So reverse an array`

The following will occur:

1. `vim-so` will detect the current `filetype`
2. `vim` will execute the following shell command: `so -t go "reverse an array"`
3. The first applicable code snippet will be pasted into the current buffer
4. You may cycle among snippets via `so#next()` and `so#prev()`


Installation
------------
`vim-so` can be installed as described in `:help packages`, or by using a
package manager like Pathogen, Vundle, or Plug.


Functions
---------
#### so#search ####
Search the Stack Overflow API for code snippets matching a phrase. It's
recommended that you map this function to a convenient command:

```vim
command -nargs=1 So call so#search(<q-args>)
```

#### so#next ####
Cycle to the next code snippet. It's recommended that you map this function to
a convenient hotkey:

```vim
nnoremap <C-N> :call so#next()<CR>
```

#### so#prev ####
Cycle to the previous code snippet. It's recommended that you map this function
to a convenient hotkey:

```vim
nnoremap <C-P> :call so#prev()<CR>
```

#### so#view ####
Open the Stack Overflow thread associated with the current code snippet in
your web browser:

```vim
command SoView :call so#view()
```


Options
-------
#### g:so_browser ####
The browser executable that should be used in conjunction with the `so#view`
function.


Configuring
-----------
Here's a practical configuration example. Add these lines to your `.vimrc`:

```vim
let g:so_browser = "firefox"
command -nargs=1 So call so#search(<q-args>)
command SoView call so#view()
nnoremap <C-N> :call so#next()<CR>
nnoremap <C-P> :call so#prev()<CR>
```


[so]: https://github.com/cheat/so
