function dashboard_footer_nvim

    # just loop any ascii art for any number of seconds
    # In this case I'm using 5
    # Can even add more variations to the loop
    # to make it look more dynamic
    while true
        fish_greeting | pv -qL 10

        sleep 10

        clear

        fish_greeting | pv -qL 10 | lolcat -at

        sleep 10
        clear
    end
end
