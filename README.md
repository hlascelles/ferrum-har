ferrum-har
================

[![Gem Version](https://img.shields.io/gem/v/ferrum-har?color=green)](https://rubygems.org/gems/ferrum-har)
[![specs workflow](https://github.com/hlascelles/ferrum-har/actions/workflows/specs.yml/badge.svg)](https://github.com/hlascelles/ferrum-har/actions)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

[ferrum-har](https://github.com/hlascelles/ferrum-har) is a gem that adds the ability to capture
[HAR](https://en.wikipedia.org/wiki/HAR_(file_format)) files while running tests
using [ferrum](https://github.com/rubycdp/ferrum).

## Installation

Add ferrum-har to your Gemfile and `bundle install`:

```ruby
gem "ferrum-har"
```

Since version 1.0, we have had to support [a change](https://developer.chrome.com/blog/extension-news-june-2025#deprecations)
to the way Chrome handles extensions which means you must use [Chrome For Testing](https://developer.chrome.com/blog/chrome-for-testing)
to use ferrum-har. This involves downloading that Chrome version as a binary.

A rake task is provided to help you download the binary, supplied by the [selenium_chrome_helper](https://github.com/pepito2k/selenium_chrome_helper) gem.
It will put it in a folder called `.chrome-for-testing` in your project root. To execute it, run:

```bash
bundle exec rake chrome:install
```

Alternatively you can use the ENV `BROWSER_PATH` to point to the binary location. Note, you can't
point it to your standard Chrome installation, it must be the Chrome Testing binary.

## Usage

Use [ferrum](https://github.com/rubycdp/ferrum) as normal and call the `har` method on
the `page` (or `browser`) object. Chrome must be used as the browser engine.

Note, the devtools window in Chrome will be opened by ferrum-har for the duration of the ferrum
test run. This is mandatory to obtain the HAR from Chrome.

```ruby
browser = Ferrum::Browser.new
page = browser.create_page
page.go_to("https://www.bbc.co.uk")
page.network.wait_for_idle

# Returns the HAR as a JSON string
puts page.har
```

## How it works

Creating a HAR file from [ferrum](https://github.com/rubycdp/ferrum) network objects is complex and
potentially incompatible with the HAR generated
by other tools (including Chrome).

Instead, ferrum-har contains a small Chrome extension that
is automatically loaded into the test browser. When the `har` method is called, this extension
asks the Chrome devtools Network panel for the HAR file and returns it to the Ruby process. This 
means the HAR is always a valid version of exactly what Chrome would produce.

The JS method that is ultimately called is `chrome.devtools.network.getHAR()` and you can read more 
about it [here](https://developer.chrome.com/docs/extensions/reference/api/devtools/network#method-getHAR).

One ramification of this is that the Chrome devtools must be open for the extension to work.

To get the extension to be loaded we must pass some switches to the Chrome process via ferrum,
specifically the `--auto-open-devtools-for-tabs` and `--load-extension` switches. This is done
by ferrum-har automatically.

For further reading, a full list of Chrome switches can be found
[here](https://peter.sh/experiments/chromium-command-line-switches/).

## Upgrading

`ferrum-har` uses [semantic versioning](https://semver.org/), so major version changes will usually 
require additional actions to be taken upgrading from one major version to another. 

## Persistent Chrome profile

You can specify the ENV `FERRUM_HAR_BROWSER_CONFIG_DIR` to point to a persistent Chrome profile dir
between runs. This will allow you to do slow setup once, then do fast reruns of your tests. Note
this should only be used for development purposes, your tests should not rely on a persistent
profile in CI.

See the [spec/acceptance/test.rb](https://github.com/hlascelles/ferrum-har/blob/master/spec/acceptance/test.rb) for
an example of how to use this.

Note, due to the flags that [ferrum](https://github.com/rubycdp/ferrum) sets, including safety features like `--disable-web-security`, you
should not use this with your real Chrome profile. It won't work, and will likely clear your cookie
cache. Instead, create a new profile directory.

## Single file example

A single file example of how to use `ferrum-har` can be found in [spec/acceptance/test.rb](https://github.com/hlascelles/ferrum-har/blob/master/spec/acceptance/test.rb).

## Changelog

A full changelog can be found here: [CHANGELOG.md](https://github.com/hlascelles/ferrum-har/blob/master/CHANGELOG.md)

```

## Further work

Some ideas for improvements.

1. Add functionality to minimise the devtools sidepanel size.
   To do this we would have to pass in a "profile" to the ferrum start switches like this:
   ```ruby
   "user-data-dir=profile" => "somedir"
   ```
   And have a "Default/Preferences" file in there that contains a sizing element like this:
   ```json
   {
     "devtools": {
       "preferences": {
         "inspector-view.split-view-state": "{\"vertical\":{\"size\":1},\"horizontal\":{\"size\":0}}"
       }
     }
   }
   ```
   However, that doesn't work as it stands as it is just a partial profile. We could add an entire
   Chrome profile but that would be hundreds of files.
2. Add GitHub Actions tests.
