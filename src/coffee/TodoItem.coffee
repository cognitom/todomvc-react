React = require 'react/addons'

ESCAPE_KEY = 27
ENTER_KEY  = 13

module.exports = React.createClass
  getInitialState: -> editText: @props.todo.title

  handleSubmit: (event) ->
    val = @state.editText.trim()
    if val
      @props.onSave val
      @setState editText: val
    else
      @props.onDestroy()

  handleEdit: ->
    # react optimizes renders by batching them. This means you can't call
    # parent's `onEdit` (which in this case triggeres a re-render), and
    # immediately manipulate the DOM as if the rendering's over. Put it as a
    # callback. Refer to app.jsx' `edit` method
    @props.onEdit =>
      node = @refs.editField.getDOMNode()
      node.focus()
      node.setSelectionRange node.value.length, node.value.length
    @setState editText: @props.todo.title

  handleKeyDown: (event) ->
    if event.which == ESCAPE_KEY
      @setState editText: @props.todo.title
      @props.onCancel event
    else if event.which == ENTER_KEY
      @handleSubmit event

  handleChange: (event) -> @setState editText: event.target.value

  shouldComponentUpdate: (nextProps, nextState) ->
    nextProps.todo != @props.todo or nextProps.editing != @props.editing or nextState.editText != @state.editText

  render: ->
    <li className={React.addons.classSet({
      completed: @props.todo.completed,
      editing: @props.editing
    })}>
      <div className="view">
        <input
          className="toggle"
          type="checkbox"
          checked={@props.todo.completed}
          onChange={@props.onToggle}
        />
        <label onDoubleClick={@handleEdit}>
          {@props.todo.title}
        </label>
        <button className="destroy" onClick={@props.onDestroy} />
      </div>
      <input
        ref="editField"
        className="edit"
        value={@state.editText}
        onBlur={@handleSubmit}
        onChange={@handleChange}
        onKeyDown={@handleKeyDown}
      />
    </li>
