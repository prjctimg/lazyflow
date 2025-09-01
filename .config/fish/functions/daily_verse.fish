#!/bin/fish
# ==============================================================================
#
# Description:
# Displays a random verse from a local JSON file as the
# terminal greeting. It requires 'jq' to be installed for parsing the JSON.
#
# ==============================================================================

function daily_verse
    # Define the path to your verses JSON file.
    # You might want to adjust this path based on where you saved the file.
    set -l verse_file "$HOME/.config/fish/verses.json"

    set -l day_of_month (date +%d | sed 's/^0*//' | string trim)
    set -l index (math "$day_of_month" - 1)
    # Ensure the file exists before trying to read it
    if not test -f "$verse_file"
        echo "Welcome to fish! (Verses file not found: $verse_file)"
        return
    end

    set -l current_hour (date +%H)


    # Use 'jq' to read the JSON file, get the current day of the month,
    # and use it as an index to pick a verse.

    # Use 'jq' to extract the verse at the calculated index
    set -l verse (jq -r ".[$index % length].text" < "$verse_file")

    set -l verse_ref (jq -r ".[$index % length].reference" < "$verse_file")
    # Print the verse, with some styling

    if test $current_hour -lt 12
        echo $(random choice "🌅" "🌄" "🍃" )
    else if test $current_hour -lt 18
        echo $(random choice "🏙️" "🏖️" )
    else
        echo $(random choice "🌆" "🌇"  "🌃" "🌉" "")
    end
    # printf (set_color green)"Day $day_of_month\n\n"(set_color normal)

    echo ""
    printf (set_color cyan)"%s"(set_color normal)"\n" "$verse"

    echo ""
    printf (set_color blue)"%s"(set_color normal)"\n" "📜 $verse_ref"

end
