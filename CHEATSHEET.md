---
fontsize: 8pt
fontfamily: inter
geometry:
  - margin=7mm
---

## General Keymaps

To list all the defined and default keymaps, enter the command `:map`
(or for a *better* output `:Telescope keymaps `). CGNvim tries to simplify
the memorization of keymaps by relying on mnemonics.

The main keymaps that contribute the most at simplifying the usual workflow are
listed below (`<leader>` is `<Space>` unless the default configuration is changed).

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Keymap              Mode      Short Description                                 Detailed Description                                                                                         
------------------- --------- ------------------------------------------------- ----------------------------------------------------------------------------------------------------------------
`<leader>tt`        n         **t**oggle **t**erminal                           toggle the integrated terminal                                                                                

`<leader>ex`        n         toggle file **ex**plorer                          toggle the *nvim-tree* file explorer                                                                             

`<leader>rw`        n         **r**ename **w**ord                               rename all occurences of the word under cursor in current buffer (without LSP usage)

`<leader>ts`        n,v,x     **t**oggle **s**pell                              toggle spell checking for current buffer                                                                          

`<leader>ss`        n         **s**pell **s**uggest                             show Telescope's spell suggestion for the word under the cursor                                               

`<leader>tr`        n,v,x     **t**oggle **r**elative line numbering            toggle relative line numbering (default: off)                                                                 

`<leader>d`         n,v,x     **d**elete to void register                       delete to void register (without copying). Vim's default delete overwrites the content of the register      

`<leader>y`         n,v,x     **y**ank to system clipboard                      copy (yank) to system clipboard. Might require an external package for support on Wayland                     

`J`                 x         move selected line(s) down(**↓**)                                                                                                                             

`K`                 x         move selected line(s) up                                                                                                                               

`J`                 n         append line below to current line                                                                                                                         
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Window Navigation and Resizing Keymaps

--------------------------------------------------------------------------------
Keymap            Mode        Short Description                                 
----------------- ----------- --------------------------------------------------
`<C-h>`           n           move to left window (**h** is on the right)

`<C-j>`           n           move to down(j) window (j is **↓**)

`<C-k>`           n           move to up window (**k** is opposite of j)

`<C-l>`           n           move to right window (**l** is on the right)            

`<C-Up>`          n           resize window size **Up**wards             

`<C-Down>`        n           resize window size **Down**wards           

`<C-Left>`        n           resize window size **Left**wards           

`<C-Right>`       n           resize window size **Right**wards          

`<S-l>`           n           navigate to right buffer (**l** is on the right)

`<S-h>`           n           navigate to left buffer (**h** is on the left)
--------------------------------------------------------------------------------

## File Explorer Keymaps

Only common keymaps are listed

--------------------------------------------------------------------------------
Keymap            Mode        Short Description                         
----------------- ----------- --------------------------------------------------
`g?`              n           **g**o to help(**?**) window to show keymaps    

`v<CR>`           n           open(**<CR>**) **v**ertically                   

`a`               n           **a**ppend/create file/folder               

`y`               n           **y**ank basename to system clipboard       

`Y`               n           **Y**ank file/directory absolute path       

`c`               n           copy file **c**ontent                       

`d`               n           **d**elete file/directory                   

`r`               n           **r**ename file/directory                   

`Tab`             n           preview file/expand directory             

`K`               n           show file metadata info                   

`.`               n           run command on current(**.**) entry           

`<leader>tg`      n           **t**oggle **g**itignore filter               

`<leader>td`      n           **t**oggle **d**otfiles filter               
--------------------------------------------------------------------------------

## Formatting Keymaps

--------------------------------------------------------------------------------------------------------------------------------------------------
Keymap            Mode        Short Description                         Detailed Description
----------------- ----------- ----------------------------------------- --------------------------------------------------------------------------
`fb`              n           **f**ormat **b**uffer                     format current buffer according to [conform.nvim][conform] config         

`<C-I>`           n           same as **fb**                            VSCode formatting shortcut                                                
--------------------------------------------------------------------------------------------------------------------------------------------------

## Git Keymaps

--------------------------------------------------------------------------------------------------------------------------------------------------
Keymap            Mode         Short Description                         Detailed Description
----------------- ------------ ----------------------------------------- -------------------------------------------------------------------------
`<leader>gsb`     n            **g**it **s**tage **b**uffer              stage the whole current buffer                       

`<leader>grb`     n            **g**it **r**eset **b**uffer              reset the whole current buffer                       

`<leader>gph`     n            **g**it **p**review **h**unk              highlight hunk under cursor if a hunk is present     

`<leader>gsh`     n            **g**it **s**tage **h**unk                stage hunk under cursor if a hunk is present         

`<leader>grh`     n            **g**it **r**eset **h**unk                reset hunk under cursor if a hunk is present         

`]h`              n            next (**[** on the right) **h**unk        navigate to next hunk                                

`[h`              n            prev (**[** on the left) **h**unk         navigate to previous hunk                            

`<leader>gdv`     n            **g**it **d**iff **v**iew                 show git diff view for current buffer                

`<leader>gtb`     n            **g**it **t**oggle **b**lame              toggle git blame for current line under cursor       
--------------------------------------------------------------------------------------------------------------------------------------------------

## Diagnostics Keymaps

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Keymap                          Mode             Short Description                                      Detailed Description                                                                                                                                                                                                        
------------------------------- ---------------- ------------------------------------------------------ ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
`]d`                            n                next(**]** is on the right) **d**iagnostics            navigate to next diagnostics (powered by LSP)

`[d`                            n                prev(**[** is on the left) **d**iagnostics             navigate to previous diagnostics (powered by LSP)

`<leader>vt`                    n                toggle **v**irtual **t**ext diagnostics                toggle virtual text diagnostics. Shows diagnostics at the right of the corresponding line using virtual text

`<leader>vl`                    n                toggle **v**irtual **l**ines diagnostics               toggle virtual lines diagnostics. Uses multiple virtual lines under the corresponding line to show diagnostics. Better than virtual text diagnostics but consumes more visual space (i.e., adds a lot of lines on hover)

`<leader>ed`                    n                **e**xplain **d**iagnostics                            explain diagnostics under cursor

`<leader>ql`                    n                **q**uickfix **l**ist                                  toggles the quickfix list window

`<leader>bd`                    n                **b**uffer **d**iagnostics                             toggle Trouble's buffer (local) diagnostics window

`<leader>gd`                    n                **g**lobal **d**iagnostics                             toggle Trouble's global diagnostics window
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## LSP Keymaps

These are only enabled when an LSP client is attached (i.e., when an LSP is successfully instantiated for the current buffer).

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Keymap                          Mode              Short Description                         Detailed Description                                                         
------------------------------- ----------------- ----------------------------------------- -----------------------------------------------------------------------------
`K`                             n                 show LSP **K**ownledge                    LSP hover information about symbol under cursor                              

`KK`                            n                 **K**indly jump to LSP **K**ownledge      jumps to LSP hover information window about symbol under cursor              

`gd`                            n                 **g**o **d**efinition                     go to the definition of the symbol under cursor                              

`gi`                            n                 **g**o **i**mplementation                 go to the implmentation of the symbol under cursor                           

`gD`                            n                 **g**o **D**eclaration                    go to the declaration of the symbol under cursor                             

`gr`                            n                 **g**o **r**eferences                     go to the references of symbol under cursor                                  

`<leader>ih`                    n                 **i**nlay **h**ints                       toggle LSP inlay hints. E.g., uses virtual text to show parameter names)     

`<leader>ca`                    n                 **c**ode **a**ction                       list code actions available for symbol under cursor                          

`<leader>rs`                    n                 **r**ename **s**ymbol                     rename symbol under the cursor and all of its references using LSP           
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Debugging Keymaps

---------------------------------------------------------------------------------------------------------
Keymap                          Mode              Short Description                         
------------------------------- ----------------- -------------------------------------------------------
`<leader>dc`                    n                 **d**ebugger **c**ontinue/start              

`<leader>db`                    n                 **d**ebugger toggle **b**reakpoint           

`<leader>do`                    n                 **d**ebugger step **o**ver                   

`<leader>di`                    n                 **d**ebugger step **i**nto                   

`<leader>dO`                    n                 **d**ebugger step **O**ut                    

`F5`                            n                 same as `<leader>dc` (for VSCode users)

`F10`                           n                 same as `<leader>do` (for VSCode users)

`F11`                           n                 same as `<leader>di` (for VSCode users)

`F12`                           n                 same as `<leader>dO` (for VSCode users)
---------------------------------------------------------------------------------------------------------

## Documentation Keymaps

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Keymap                          Mode              Short Description                                                                            
------------------------------- ----------------- ------------------------------------------------------------------------------------------------------------------------------------------------
`<leader>ng`                    n                 **N**eogen **g**enerate documentation for the class/function/type under current cursor context (useful for C# XML docs, Python docstrings, etc)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

[conform]: https://github.com/stevearc/conform.nvim/tree/master
