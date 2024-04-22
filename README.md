ferrum-har
================

[![Gem Version](https://img.shields.io/gem/v/ferrum-har?color=green)](https://img.shields.io/gem/v/ferrum-har?color=green)

[ferrum-har](https://github.com/hlascelles/ferrum-har) is a gem that adds the ability to capture
[HAR](https://en.wikipedia.org/wiki/HAR_(file_format)) files while running tests
using [ferrum](https://github.com/rubycdp/ferrum).

### Installation

Add ferrum-har to your Gemfile and `bundle install`:

```ruby
gem "ferrum-har"
```

### Usage

Use [ferrum](https://github.com/rubycdp/ferrum) as normal and call the `har` method on
the `page` (or `browser`) object. Note, you will have to use some of the required browser options
by using the `Ferrum::Har::REQUIRED_BROWSER_OPTIONS` constant. 

Note, the devtools window in Chrome will be opened. This is mandatory to obtain the HAR from Chrome.

```ruby
browser = Ferrum::Browser.new(
  browser_options: Ferrum::Har::REQUIRED_BROWSER_OPTIONS,
)
page = browser.create_page
page.go_to("https://www.bbc.co.uk")

# Returns the HAR as a JSON string
puts page.har
```

### How it works

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
by the `Ferrum::Har::REQUIRED_BROWSER_OPTIONS` constant.

For further reading, a full list of Chrome switches can be found
[here](https://peter.sh/experiments/chromium-command-line-switches/).

### Further work

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

## Upgrading

`ferrum-har` uses [semantic versioning](https://semver.org/), so major version changes will usually 
require additional actions to be taken upgrading from one major version to another. 

## Changelog

A full changelog can be found here: [CHANGELOG.md](https://github.com/hlascelles/ferrum-har/blob/master/CHANGELOG.md)
