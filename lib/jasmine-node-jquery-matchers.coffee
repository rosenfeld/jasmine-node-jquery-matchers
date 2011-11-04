exports.options = options = hiddenClass: 'hidden'

jQueryMatchers =
    toHaveClass: (className) -> @actual.hasClass(className)
    toBeVisible: -> @actual.is(':visible')
    toBeHidden: -> @actual.is(':hidden')
    toBeAllVisible: -> not @actual.filter(':hidden').length
    toBeAllHidden: -> not @actual.filter(':visible').length
    toBeCssHidden: (hiddenClass) -> @actual.hasClass(hiddenClass or options.hiddenClass)
    toBeCssVisible: (hiddenClass) -> not @actual.hasClass(hiddenClass or options.hiddenClass)
    toBeAllCssVisible: (hiddenClass) -> not @actual.filter(".#{hiddenClass or options.hiddenClass}").length
    toBeAllCssHidden: (hiddenClass) -> not @actual.filter(":not(.#{hiddenClass or options.hiddenClass})").length
    toBeSelected: -> @actual.is(':selected')
    toBeChecked: -> @actual.is(':checked')
    toBeEmpty: -> @actual.is(':empty')
    toExist: -> @actual.length
    toHaveAttr: (attributeName, expectedAttributeValue) ->
      hasProperty @actual.attr(attributeName), expectedAttributeValue
    toHaveId: (id) -> @actual.attr('id') is id
    toHaveHtml: (html) -> @actual.html() is options.jQuery('<div/>').append(html).html()

    toHaveText: (text) ->
      #if options.jQuery.isFunction text?.test
      if typeof text?.test == "function"
        text.test @actual.text()
      else
        @actual.text() is text

    toHaveValue: (value) -> return @actual.val() is value

    toHaveData: (key, expectedValue) -> hasProperty @actual.data(key), expectedValue
    toBe: (selector) -> @actual.is(selector)
    toContain: (selector) -> @actual.find(selector).length
    toBeDisabled: (selector) -> @actual.is(':disabled')
    # tests the existence of a specific event binding
    toHandle: (eventName) ->
      events = @actual.data("events")
      events and events[eventName].length
    # tests the existence of a specific event binding + handler
    toHandleWith: (eventName, eventHandler) ->
      for ev in @actual.data("events")[eventName]
        return true if ev.handler == eventHandler
      false

hasProperty = (actualValue, expectedValue) ->
  return actualValue isnt undefined if expectedValue is undefined
  actualValue is expectedValue

exports.matchers = matchers = {}

registerMatcher = (name, handler) ->
  builtInMatcher = jasmine.Matchers.prototype[name]
  matchers[name] = ->
    if @actual instanceof options.jQuery
      result = handler.apply(this, arguments)
      #@actual = options.jQuery('<div />').append(@actual.clone()).html()
      @actual = @actual[0]?.outerHTML or '[empty jQuery selection]'
      return result

    return builtInMatcher.apply(this, arguments) if builtInMatcher
    false

registerMatcher(name, handler) for name, handler of jQueryMatchers
