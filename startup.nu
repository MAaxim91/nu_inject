def "config directory" [] { config path | path dirname }

def edit [
    filepath: path # Path to file
    --editor (-e): string   # Use a different editor (default is `$nu.env.EDITOR`)
] {
    let editor = (if $editor != "" { $editor } { $nu.env.EDITOR });
    ^$editor $filepath
}

def "config edit" [
    --editor (-e): string   # Use a different editor (default is `$nu.env.EDITOR`)
] {
    let editor = (if $editor != "" { $editor } { $nu.env.EDITOR })
    edit (config path)
}

def "config explorer" [] {
    ^explorer (config directory)
}

def "startup" [] { help startup }

def "startup path" [] { config path | path dirname | append startup.nu | path join }

def "startup edit" [
    --editor (-e): string   # Use a different editor (default is `$nu.env.EDITOR`)
] {
    let editor = (if $editor != "" { $editor } { $nu.env.EDITOR })
    edit (startup path)
}

def "optionals directory" [] {
    (config directory | path join optional)
}

def optionals [] {
    echo $"Allowed optionals:(char nl)"
    ls $"(optionals directory)/*.nu" | get name | path basename | str find-replace ".nu" "" | each { |s| $"  - ($s)" } | str collect (char nl)
}

def "optionals edit" [
    name: string # name of optional file
    --editor (-e): string   # Use a different editor (default is `$nu.env.EDITOR`)
] {
    let editor = (if $editor != "" { $editor } { $nu.env.EDITOR });
    let filepath = (optionals directory | path join $"($name).nu")
    edit $filepath
}

let-env CONFIG_DIRECTORY = (config directory)


def numbered [] {
    each --numbered { [[num]; [$it.index]] | merge {$it.item} }
}

def replicate [
    str: string # Text to repeat
    count: int # Repeat count
] {
    "" | str lpad -c $"($str)" -l $count
}

alias style_red_bold = ansi -e '31;1m'
alias style_purple_underline = ansi -e '35;4m'
alias style_white_italic = ansi -e '97;3m'
alias style_clear = ansi -e '0m'

def error [
    title:any
    message:any
] {
    echo $"(style_red_bold)[ERORR](style_clear) (style_purple_underline)($title):(style_clear) (style_white_italic)($message)(style_clear)"
}

# copy unicode character into clipboard
def uniclip [
    hex: string # Unicode hex number (2FF0)
] {
    char -u $hex | clip
}

def base64 [
    --decode(-d) # decode base64
] {
    if ($decode | empty?) {
        python -c "import base64,sys; sys.stdout.buffer.write(base64.b64encode(sys.stdin.buffer.read()))"
    } {
        python -c "import base64,sys; sys.stdout.buffer.write(base64.b64decode(sys.stdin.buffer.read()))"
    }
}
