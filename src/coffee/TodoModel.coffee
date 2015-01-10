uuid   = require 'node-uuid'
extend = require 'extend'

store = (namespace, data) ->
  # set
  return localStorage.setItem namespace, JSON.stringify data if data
  # get
  s = localStorage.getItem namespace
  (s && JSON.parse s) || []

module.exports = class
  constructor: (@key) ->
    @todos = store @key
    @onChanges = []

  subscribe: (onChange) -> @onChanges.push onChange

  inform: ->
    store @key, @todos
    onChange() for onChange in @onChanges

  addTodo: (title) ->
    @todos = @todos.concat
      id: uuid.v4()
      title: title
      completed: false
    @inform()

  toggleAll: (checked) ->
    @todos = @todos.map (todo) ->
      extend {}, todo, completed: checked
    @inform()

  toggle: (target) ->
    @todos = for todo in @todos
      todo = extend {}, todo, completed: !todo.completed if todo == target
      todo
    @inform()

  save: (target, text) ->
    @todos = for todo in @todos
      todo = extend {}, todo, title: text if todo == target
      todo
    @inform()

  destroy: (todo) ->
    @todos = @todos.filter (candidate) -> candidate != todo
    @inform()

  clearCompleted: ->
    @todos = @todos.filter (todo) -> !todo.completed
    @inform()
