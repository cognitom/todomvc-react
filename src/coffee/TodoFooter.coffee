React     = require 'react/addons'
pluralize = require 'pluralize'
cx        = React.addons.classSet # React idiom

ALL_TODOS       = 'all'
ACTIVE_TODOS    = 'active'
COMPLETED_TODOS = 'completed'

module.exports = React.createClass
  render: ->
    activeTodoWord = pluralize 'item', @props.count

    clearButton = if @props.completedCount > 0
      <button
        id="clear-completed"
        onClick={@props.onClearCompleted}>
        Clear completed ({@props.completedCount})
      </button>

    nowShowing = @props.nowShowing

    <footer id="footer">
      <span id="todo-count">
        <strong>{@props.count}</strong> {activeTodoWord} left
      </span>
      <ul id="filters">
        <li>
          <a
            href="#/"
            className={cx({selected: nowShowing == ALL_TODOS})}>
              All
          </a>
        </li>
        <li>
          <a
            href="#/active"
            className={cx({selected: nowShowing == ACTIVE_TODOS})}>
              Active
          </a>
        </li>
        <li>
          <a
            href="#/completed"
            className={cx({selected: nowShowing == COMPLETED_TODOS})}>
              Completed
          </a>
        </li>
      </ul>
      {clearButton}
    </footer>
