
function dashboard_greeter_nvim

    set options square alpha crunchbang-mini six fade suckless
    while true
        set choice $options[(math (random) % (count $options) + 1)]

        colorscript -e $choice | pv -qL 80 | lolcat -at

        sleep 6
        clear
    end



end
