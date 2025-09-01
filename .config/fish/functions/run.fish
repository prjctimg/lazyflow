
function run


    if not set -q argv[1]

        echo "Usage $0 <file>"
        exit 1
    end

    set file $argv[1]
    set ext (echo $file | awk -F '.' '{print $NF}')


    if test "$ext" = "$file"
        if not test -x $file
            echo "File not executable."
            chmod +x $file
            echo "File made executable. Running it..."
            $file
        else
            $file
        end
    else
        switch $ext
            case lua

                lua $file

            case js ts mts mjs cjs


                bun $file


            case sh
                bash $file
            case go

                go run $argv $file
            case zig

                zig run $file
        end
    end
end
