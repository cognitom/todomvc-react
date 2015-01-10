React     = require 'react/addons'
domready  = require 'domready'
TodoApp   = require './TodoApp'
TodoModel = require './TodoModel'

model = new TodoModel 'react-todos'

render = -> React.render <TodoApp model={model}/>, document.getElementById 'todoapp'
model.subscribe render

domready -> render()
