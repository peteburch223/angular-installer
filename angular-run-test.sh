#!/bin/bash
current_dir=$(pwd)

osascript -e "tell app \"Terminal\"
    do script \"http-server $current_dir/app\"
end tell"

osascript -e "tell app \"Terminal\"
    do script \"cd $current_dir &&  webdriver-manager start\"

end tell"

# the sleep values are not optimised
sleep 2
protractor test/protractor.conf.js

sleep 5
karma start test/karma.conf.js
