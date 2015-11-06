React = require('react')
{Component, PropTypes, DOM} = React

Counter = React.createClass
  render: ->
    {increment, incrementIfOdd, incrementAsync, decrement, counter} = @props
    sp = ' '

    DOM.p {}, [
      "Clicked: #{counter} times"
      sp
      DOM.button {onClick: increment}, '+'
      sp
      DOM.button {onClick: decrement}, '-'
      sp
      DOM.button {onClick: incrementIfOdd}, 'Increment if odd'
      sp
      DOM.button {onClick: -> incrementAsync()}, 'Increment async'
    ]

  propTypes:
    increment: PropTypes.func.isRequired,
    incrementIfOdd: PropTypes.func.isRequired,
    incrementAsync: PropTypes.func.isRequired,
    decrement: PropTypes.func.isRequired,
    counter: PropTypes.number.isRequired

module.exports = Counter
