
return {
{ 'echasnovski/mini.files', version = '*' ,
config =  function()
    local mini_files = require('mini.files')
    mini_files.setup({
 -- General options
  options = {
    -- Whether to delete permanently or move into module-specific trash
    permanent_delete = false,
    -- Whether to use for editing directories
    use_as_default_explorer = true,
  },
    })

    vim.keymap.set('n', '-', mini_files.open)
end



}
}
