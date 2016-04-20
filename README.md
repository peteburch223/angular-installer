Angular Setup Script
==================
Description of Project
----------------------
This script is based on walkthoughs created by Makers Academy, and aims to simplify setting up a basic Angular project.
It performs the following tasks:
- checks for JDK and Node/NPM prerequisites and exits if they are not present.
- creates a project directory structure beneath a root directory from path passed on command line.
- initialises a git repo
- installs Bower
- installs Angular
- installs Protractor and Karma testing frameworks
- creates a skeleton Angular app that demonstrates basic feature and unit testing

Installation instructions
-------------------------
- Clone the git repo
- save scripts `angular-init.sh`  & `angular-run-test.sh` to an appropriate location (eg `~/bin`)
- add path to script to $PATH, if necessary

Execution instructions
----------------------
- navigate to parent directory of project you want to create
- `source angular-init.sh <project-name>`
- `angular-run-test.sh` to launch webdriver and webserver, and to run basic feature and unit tests

Copyright notice
----------------
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

Version 0.1
-----------
This is an initial version of a script that has been very lightly tested...


Authors
-------
Initial coding: Pete BURCH - peteburch223@gmail.com
