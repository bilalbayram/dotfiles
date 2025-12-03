function helium --description "Open URL or file in Helium browser ||"
    if test (count $argv) -eq 0
        open -a "Helium"
    else
        open -a "Helium" $argv
    end
end
