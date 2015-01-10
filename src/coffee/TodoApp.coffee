React      = require 'react/addons'
{Router}   = require 'director'
TodoFooter = require './TodoFooter'
TodoItem   = require './TodoItem'

ENTER_KEY       = 13
ALL_TODOS       = 'all'
ACTIVE_TODOS    = 'active'
COMPLETED_TODOS = 'completed'

module.exports = React.createClass
  getInitialState: ->
    nowShowing: ALL_TODOS
    editing: null

  componentDidMount: ->
    router = Router
      '/':          => @setState nowShowing: ALL_TODOS
      '/active':    => @setState nowShowing: ACTIVE_TODOS
      '/completed': => @setState nowShowing: COMPLETED_TODOS
    router.init '/'

  handleNewTodoKeyDown: (event) ->
    return if event.which != ENTER_KEY
    event.preventDefault()

    if val = @refs.newField.getDOMNode().value.trim()
      @props.model.addTodo val
      @refs.newField.getDOMNode().value = ''

  toggleAll: (event) ->
    checked = event.target.checked
    @props.model.toggleAll checked

  toggle: (todo) -> @props.model.toggle todo

  destroy: (todo) -> @props.model.destroy todo

  edit: (todo, callback) ->
    # refer to todoItem.js `handleEdit` for the reasoning behind the
    # callback
    @setState
      editing: todo.id
    , -> callback()

  save: (todoToSave, text) ->
    @props.model.save todoToSave, text
    @setState editing: null

  cancel: -> @setState editing: null

  clearCompleted: -> @props.model.clearCompleted()

  render: ->
    todos = @props.model.todos

    shownTodos = todos.filter (todo) ->
      switch @state.nowShowing
        when ACTIVE_TODOS then !todo.completed
        when COMPLETED_TODOS then todo.completed
        else true
    , @

    todoItems = shownTodos.map (todo) =>
      <TodoItem
        key={todo.id}
        todo={todo}
        onToggle={=> @toggle todo}
        onDestroy={=> @destroy todo}
        onEdit={(cb) => @edit todo, cb}
        editing={@state.editing == todo.id}
        onSave={(val) => @save todo, val}
        onCancel={@cancel}
      />

    activeTodoCount = todos.reduce (accum, todo) ->
      if todo.completed then accum else accum + 1
    , 0

    completedCount = todos.length - activeTodoCount

    footer = if activeTodoCount || completedCount
      <TodoFooter
        count={activeTodoCount}
        completedCount={completedCount}
        nowShowing={@state.nowShowing}
        onClearCompleted={@clearCompleted}
      />

    main = if todos.length
      <section id="main">
        <input
          id="toggle-all"
          type="checkbox"
          onChange={@toggleAll}
          checked={activeTodoCount == 0}
        />
        <ul id="todo-list">
          {todoItems}
        </ul>
      </section>

    <div>
      <header id="header">
        <h1>todos</h1>
        <input
          ref="newField"
          id="new-todo"
          placeholder="What needs to be done?"
          onKeyDown={@handleNewTodoKeyDown}
          autoFocus={true}
        />
      </header>
      {main}
      {footer}
    </div>
