#!/bin/bash
trap "exit" INT
dir_name=$1
clear

echo "checking for JDK install"
JAVA_VER=$(java -version 2>&1 | sed 's/java version "\(.*\)\.\(.*\)\..*"/\1\2/; 1q')

if [ -z $JAVA_VER ]; then
  echo "You need to install JDK from https://helpx.adobe.com/x-productkb/global/install-java-jre-mac-os.html before continuing"
  return
else
  echo "Java $JAVA_VER detected"
fi

current_dir=$(pwd)
echo "current directory "$current_dir
if [ -n "$dir_name" ]; then
  proj_root=$current_dir'/'$dir_name
  echo "Setting up angular in directory $proj_root"
  if [ ! -d "$dir_name" ]; then
    echo "creating directory "$dir_name
    mkdir $dir_name
  fi
  cd $proj_root
else
  echo "no project directory specified"
  return
fi

git init
touch README.md

echo "checking for node"
node_version=$(node -v)
echo "$node_version"

if [ -z $node_version ]; then
  echo "node not installed, installing with brew"
  brew install node
fi



npm init -f
npm install bower -g --save-dev
echo "*** Setting up Bower ***"

echo "creating app directory"
touch .bowerrc
printf "%s\n" "{" "  \"directory\": \"app/bower_components\"" "}" > .bowerrc
mkdir app

# need to figure out how to get angular version
printf "%s\n" "{" \
              "  \"name\": \"$dir_name\"," \
              "  \"description\": \"<project description>\"," \
              "  \"main\": \"app/js/app.js\"," \
              "  \"authors\": \"[$USER]\"," \
              "  \"license\": \"ISC\"," \
              "  \"ignore\": [" \
              "    \"**/.*\"," \
              "    \"node_modules\"," \
              "    \"bower_components\"," \
              "    \"test\"," \
              "    \"tests\"" \
              "  ]," \
              "  \"dependencies\": {" \
              "    \"angular\": \"^1.5.5\"" \
              "  }," \
              "  \"devDependencies\": {" \
              "    \"angular-mocks\": \"^1.5.5\"" \
              "  }" \
              "}" \
              > bower.json

bower install



echo "*** Install Angular ***"
bower install angular --save

# END OF WALKTHROUGH 8


cd $proj_root
echo "*** Install Protractor ***"
npm install -g protractor
npm install --save-dev protractor
echo "*** Update Webdriver Manager ***"
webdriver-manager update

echo "*** Create Protractor config file ***"

mkdir test
touch test/protractor.conf.js
printf "%s\n" "exports.config = {" \
              "  seleniumAddress: 'http://localhost:4444/wd/hub'," \
              "  specs: ['e2e/*.js']," \
              "  baseUrl: 'http://localhost:8080'" \
              "}" \
              > test/protractor.conf.js

echo "*** Install http-server ***"
npm install --save http-server
npm install http-server -g


echo "*** Create primary app files"
mkdir app/js
touch app/js/app.js
printf "%s\n" "var toDoApp = angular.module('toDoApp', []);" > app/js/app.js

touch app/index.html

printf "%s\n" "<!doctype html>" \
              "<html lang=\"en\" ng-app=\"toDoApp\">" \
              " <head>" \
              "   <meta charset=\"utf-8\">" \
              "   <script src=\"bower_components/angular/angular.js\"></script>" \
              "   <script src=\"js/app.js\"></script>" \
              "   <title>Todos App</title>" \
              " </head>" \
              " <body>" \
              "   <p>Hello world<p>" \
              " </body>" \
              "</html>" \
              > app/index.html

echo "*** Create sample test"

mkdir test/e2e
touch test/e2e/todoFeatures.js

printf "%s\n" "describe('Todos tracker', function() {" \
              "  it('has a title', function() {" \
              "    browser.get('/');" \
              "    expect(browser.getTitle()).toEqual('Todos App');" \
              "  });" \
              "});" \
              > test/e2e/todoFeatures.js


touch .gitignore
printf "%s\n" "node_modules" "app/bower_components" > .gitignore

echo "Script completed successfully"
