exports.jQueryContainer = container = {}

jQueryMatchers =
    toHaveClass: (className) -> @actual.hasClass(className)
    toBeVisible: -> @actual.is(':visible')
    toBeHidden: -> @actual.is(':hidden') or @actual.hasClass('hidden')
    toBeSelected: -> @actual.is(':selected')
    toBeChecked: -> @actual.is(':checked')
    toBeEmpty: -> @actual.is(':empty')
    toExist: -> @actual.length
    toHaveAttr: (attributeName, expectedAttributeValue) ->
      hasProperty @actual.attr(attributeName), expectedAttributeValue
    toHaveId: -> @actual.attr('id') is id
    toHaveHtml: (html) -> @actual.html() is container.jQuery('<div/>').append(html).html()

    toHaveText: (text) ->
      #if container.jQuery.isFunction text?.test
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
    if @actual instanceof container.jQuery
      result = handler.apply(this, arguments)
      @actual = container.jQuery('<div />').append(@actual.clone()).html()
      return result

    return builtInMatcher.apply(this, arguments) if builtInMatcher
    false

registerMatcher(name, handler) for name, handler of jQueryMatchers
