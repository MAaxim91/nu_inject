def init-optionals [] {
    source optionals.nu

    let optional-files = (ls optional | where name =~ '.nu' | get name)
    let optional-files-str = ($optional-files | str collect ',')

    if $exists-optionals != $optional-files-str {
        echo $'let exists-optionals = "($optional-files-str)"(char nl)' | save -r optionals.nu

        echo $"def inject [] {(char nl)$(char dq)Available injects:(char lp)char nl(char rp)(char dq)(char nl)" | save -r -a optionals.nu
        $optional-files | each { |f| let fname = ($f | path basename | str find-replace ".nu" "" ); echo $"$(char dq)>  inject-($fname)(char lp)char nl(char rp)(char dq)(char nl)" | save -r -a optionals.nu }
        echo $"}(char nl)" | save -r -a optionals.nu
        $optional-files | each { |f| let fname = ($f | path basename | str find-replace ".nu" "" ); echo $"alias inject-($fname) = source (config directory | path join $f)(char nl)" | save -r -a optionals.nu }
    } {}
}