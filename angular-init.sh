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

echo "***Set up Git repo***"
git init
touch README.md

echo "checking for Node"
node_version=$(node -v)
echo "$node_version"

if [ -z $node_version ]; then
  echo "please install node"
  return
fi

echo "*** Setting up NPM ***"
npm init -f
npm install bower -g --save-dev
echo "*** Setting up Bower ***"

echo "creating app directory"
touch .bowerrc
printf "%s\n" "{" "  \"directory\": \"app/bower_components\"" "}" > .bowerrc
mkdir app

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
              "   <script src=\"js/controllers/ToDoController.js\"></script>" \
              "   <title>Todos App</title>" \
              " </head>" \
              " <body>" \
              "   <div id=\"todo\" ng-controller=\"ToDoController as controller\">" \
              "     {{ controller.todo }}" \
              "   </div>" \
              " </body>" \
              "</html>" \
              > app/index.html

echo "*** Create sample test ***"

mkdir test/e2e
touch test/e2e/todoFeatures.js

printf "%s\n" "describe('Todos tracker', function() {" \
              "  it('has a title', function() {" \
              "    browser.get('/');" \
              "    expect(browser.getTitle()).toEqual('Todos App');" \
              "  });" \
              "});" \
              > test/e2e/todoFeatures.js

mkdir test/unit
touch test/unit/ToDoController.spec.js

printf "%s\n" "describe('ToDoController', function() {" \
              "  beforeEach(module('toDoApp'));" \
              "  it('initialises with a toDo', function() {" \
              "    expect(ctrl.todo).toEqual(\"ToDo1\");" \
              "  });" \
              "  var ctrl;" \
              "  beforeEach(inject(function($controller) {" \
              "    ctrl = $controller('ToDoController');" \
              "  }));" \
              "});" \
              > test/unit/ToDoController.spec.js

mkdir app/js/controllers
touch app/js/controllers/ToDoController.js

printf "%s\n" "toDoApp.controller('ToDoController', [function() {" \
              "  this.todo = \"ToDo1\";" \
              "}]);" \
              > app/js/controllers/ToDoController.js

touch .gitignore
printf "%s\n" "node_modules" "app/bower_components" > .gitignore

echo "*** Install Karma ***"

npm install karma --save-dev
npm install karma-jasmine karma-chrome-launcher --save-dev
npm install jasmine-core --save-dev
npm install -g karma-cli
bower install angular-mocks --save-dev

echo "*** Create Karma Config file ***"
printf "%s\n" "module.exports = function(config){" \
              "  config.set({" \
              "     basePath : '../'," \
              "     files : ["  \
              "        'app/bower_components/angular/angular.js',"  \
              "        'app/bower_components/angular-mocks/angular-mocks.js',"  \
              "        'app/js/**/*.js',"  \
              "        'test/unit/**/*.js'"  \
              "      ],"  \
              "      autoWatch : true,"  \
              "      frameworks: ['jasmine'],"  \
              "      browsers : ['Chrome'],"  \
              "      port: 8080," \
              "      plugins : ["  \
              "              'karma-chrome-launcher',"  \
              "              'karma-jasmine'"  \
              "      ]"  \
              "    });"  \
              "  };"  \
              > test/karma.conf.js
echo "Script completed successfully"
