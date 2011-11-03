jasmine-node-jquery-matchers
======

jQuery matchers for Jasmine for usage under Node.js environment.

The matchers were extracted from [jasmine-jquery](https://github.com/velesin/jasmine-jquery).

Go check for the available selectors documentation there.

Differences
------

I use jsdom for writing my specs against my JavaScript/CoffeeScript code.
It seems that the ":hidden" and ":visible" jQuery selectors don't work
correctly under jsdom yet if you're using some CSS class with the 'display'
attribute set (eg.: _.hidden { display: none }_). CSS support needs to be improved in jsdom.

So, as a workaround, toBeHidden will test for the presence of the "hidden" CSS class,
in addition to checking for _:hidden_ jQuery selector in the jQuery object.

Installation
------

    npm install git://github.com/rosenfeld/jasmine-node-jquery-matchers

Usage
------

    // Adapted from an example in the jsdom documentation.
    var jsdom = require('jsdom'), jqm = require('jasmine-node-jquery-matchers'),
        already_run = false, $

    jsdom.env('<div id="dialog" class="hidden">My dialog content</div>', ['http://code.jquery.com/jquery.min.js'],
      function(errors, window) {
        jqm.jQueryContainer.jQuery = $ = window.$
        jasmine.asyncSpecDone()
      });

    beforeEach(function() { already_run = already_run || jasmine.asyncSpecWait() || true })
    beforeEach(function() { this.addMatchers(jqm.matchers) })

    describe("After jQuery is loaded", function() {
      it("#dialog should be hidden", function() {
        expect($('#dialog')).toBeHidden()
      })
    })

Since the matchers were written in CoffeeScript you'll need to call jasmine-node with _--coffee_ option set.

If you want to know how I test my client code, take a look at
[this article](http://rosenfeld.heroku.com/en/articles/programming/2011-10-05-testing-javascript-with-node-jasmine-and-sinon).

Dependencies
------

Since the matchers were written in CoffeeScript as anything else I write for
a JavaScript environment, this package also depend on CoffeeScript.

Of course it would be easy to convert it to a JavaScript only code, but really: who
isn't using CoffeeScript yet?

FAQ
------

q: Why isn't this package published under NPM yet?

a: Because I didn't use all those matchers yet and I'm not sure if they work.
But specially because I'm not comfortable with the hack mentioned under the
"Differences" topic, which can be misleading if you don't hide elements adding
the "hidden" CSS class, as I do.

q: Why should I use this untested code?

a: You don't need to. But the code is probably smaller than this README, so you
should really take a look at it and check if it would help you by yourself.

q: Can I send you a pull request removing the CoffeeScript dependency?

a: No! Really? I can't believe you asked me this! I really HATE JavaScript, as
they hurt my eyes. And although CoffeeScript is not able to support require/import
statements as it needs to compile to JavaScript, at least it is still the best
alternative to JavaScript that I'm aware about...
