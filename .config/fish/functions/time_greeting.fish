function time_greeting

    set hour (date +"%H")

    if test $hour -ge 5 -a $hour -lt 12
        set greeting "Good morning, Dean ☀️"
    else if test $hour -ge 12 -a $hour -lt 17
        set greeting "Good afternoon, Dean 🌤️"
    else if test $hour -ge 17 -a $hour -lt 21
        set greeting "Good evening, Dean 🌆"
    else
        set greeting "Burning the midnight oil, Dean? 🌙"
    end

    echo $greeting


end
