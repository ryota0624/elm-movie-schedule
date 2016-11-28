import React, {Component, PropTypes} from 'react';
import {MovieComponent} from './MovieComponent.elm';
import MovieStore from '../../store/MovieStore';
import MovieAction from '../../action/MovieAction';
import ReviewAction from '../../action/ReviewAction';
import ReviewStore from '../../store/ReviewStore';


export default class MovieViewContainer extends Component {
  constructor(props, context) {
    super(props, context)
    this.state = {
      movie: MovieStore.findById(this.props.params.id),
      review: ReviewStore.findById(this.props.params.id)
    }
    this.reviewMovie = this.reviewMovie.bind(this);
    this.backToScheduleView = this.backToScheduleView.bind(this);
    this.setReview = this.setReview.bind(this);
  }

  componentDidUpdate(prevProps, prevState) {
    this.MovieView.ports.state.send(this.state);
  }

  componentDidMount() {
    this.setMovie = this.setMovie.bind(this);
    this.MovieView = MovieComponent.embed(this.span, this.state);
    MovieAction.findById(this.props.params.id);

    MovieStore.on(this.setMovie);
    ReviewStore.on(this.setReview);

    this.MovieView.ports.onClickBackButton.subscribe(this.backToScheduleView);
    this.MovieView.ports.onClickPointButton.subscribe(this.reviewMovie);
  }

  setReview() {
    const review = ReviewStore.findById(this.props.params.id);
    this.setState({ review });
  }

  reviewMovie(review) {
    ReviewAction.reviewMovie(review);
  }

  backToScheduleView() {
    this.context.router.transitionTo(`/schedule`);
  }

  setMovie() {
    this.setState({
      movie: MovieStore.findById(this.props.params.id)
    });
  }

  componentWillUnmount() {
    MovieStore.rm(this.setMovie);
    ReviewStore.rm(this.setReview);
    this.MovieView.ports.onClickBackButton.unsubscribe(this.backToScheduleView);
    this.MovieView.ports.onClickPointButton.unsubscribe(this.reviewMovie);
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

MovieViewContainer.contextTypes = {
  router: PropTypes.object.isRequired
}