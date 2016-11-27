import React, {Component} from 'react';
import {MovieComponent} from './MovieComponent.elm';
import MovieStore from '../../store/MovieStore';
import MovieAction from '../../action/MovieAction';

export default class MovieViewContainer extends Component {
  constructor(props, context) {
    super(props, context)
    this.state = {
      movie: null
    }
  }

  componentDidUpdate(prevProps, prevState) {
    this.MovieView.ports.movie.send(this.state.movie);
  }

  componentDidMount() {
    this.setMovie = this.setMovie.bind(this);
    this.MovieView = MovieComponent.embed(this.span, this.state.movie);
    MovieAction.findById(this.props.params.id)
    MovieStore.on(this.setMovie)
  }
  setMovie() {
    this.setState({
      movie: MovieStore.findById(this.props.params.id)
    })
  }

  componentWillUnmount() {
   MovieStore.rm(this.setMovie)
 }

  render() {
   return (
    <span ref={(span) => {
        this.span = span
      }}>
      </span>
   )
  }
}
