# ALARM

A simple web front-end for Podcast Producer's Podcast Library. Includes basic web-based management of feed, catalog metadata and images, as well as episode metadata. Access control using existing Podcast Producer LDAP authentication.

[Here](http://radio.larm-archive.org) is an in-production example of `alarm`.

## Stack
* Bundler
* Sinatra
* Mongoid
* Compass
* Susy
* Rakismet
* Net/LDAP

## Installation

1. `brew install mongodb`
2. `mv conf/settings.yml.default conf/settings.yml` and edit
3. `bundle install`
4. `rackup`

Please note that you will need to relax permissions for your library `Content` and `UUIDs` folders and subfolders to allow for episode metadata editing. Please let me know if you have a better solution!

## License

The MIT License

Copyright (c) 2011 Copenhagen University

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
