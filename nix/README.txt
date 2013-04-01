findporn
=============

Track new releases on pornolab.net

Installation from a binary distribution:
-------

* Install java 1.6 or higher from http://www.java.com/
* Download the latest .zip or .tar.gz file from https://sourceforge.net/projects/findporn/files/
* Unpack it
* Set your login and password for pornolab.net in config.yml
* Add your queries to queries.txt (you'll find instructions and examples in that file)
* Run findporn.sh (Linux or Mac) or findporn.bat (Windows). Use -v command line option for verbose output
* Results will show up in result.html

Compiling from sources (for Linux and Mac users, not available for Windows yet)
-------

* Install JRuby from http://jruby.org/
* Install Bundler from http://gembundler.com/
* Clone git repo: https://github.com/pdrdev/findporn.git
* Run "bundle install"
* Run "bundle exec rake"
* .tar.gz and .zip files will show up in pkg directory

