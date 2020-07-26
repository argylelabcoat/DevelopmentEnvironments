source "%val{config}/plugins/plug.kak/rc/plug.kak"

plug "andreyorst/kaktree" config %{
    hook global WinSetOption filetype=kaktree %{
        remove-highlighter buffer/numbers
        remove-highlighter buffer/matching
        remove-highlighter buffer/wrap
        remove-highlighter buffer/show-whitespaces
    }
    kaktree-enable
}


plug "andreyorst/tagbar.kak" defer "tagbar" %{
    set-option global tagbar_sort false
    set-option global tagbar_size 40
    set-option global tagbar_display_anon false
} config %{
    # if you have wrap highlighter enamled in you configuration
    # files it's better to turn it off for tagbar, using this hook:
    hook global WinSetOption filetype=tagbar %{
        remove-highlighter window/wrap
        # you can also disable rendering whitespaces here, line numbers, and
        # matching characters
    }
}

plug "andreyorst/powerline.kak" config %{
    powerline-start
}

plug "ul/kak-lsp" do %{
    cargo install --locked --force --path .
}
