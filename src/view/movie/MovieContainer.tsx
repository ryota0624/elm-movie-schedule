import { Component, PropTypes } from 'react';
import * as React from 'react';
import MovieStore from '../../store/MovieStore';
import ReviewStore from '../../store/ReviewStore';

import MovieAction from '../../action/MovieAction';
import ReviewAction from '../../action/ReviewAction';

import { Movie } from '../../model/Movie';
import { Review } from '../../model/Review';

const {MovieComponent} = require('./MovieComponent.elm');

type MovieViewContainerProps = {
  params: {
    id: string
  }
}

type MovieViewContainerState = {
  movie?: Movie
  review?: Review
}

export default class MovieViewContainer extends Component<MovieViewContainerProps, MovieViewContainerState> {
  static contextTypes = {
    router: PropTypes.object.isRequired
  }
  span: any
  MovieView: any
  context: { router: any }
  constructor(props, context) {
    super(props, context)
    this.state = {
      movie: MovieStore.findById(this.props.params.id),
      review: ReviewStore.findById(this.props.params.id)
    }
    this.reviewMovie = this.reviewMovie.bind(this);
    this.backToScheduleView = this.backToScheduleView.bind(this);
    this.setReview = this.setReview.bind(this);
    this.removeReview = this.removeReview.bind(this);
  }

  componentDidUpdate(prevProps, prevState) {
    this.MovieView.ports.state.send(this.state);
  }

  componentDidMount() {
    this.setMovie = this.setMovie.bind(this);
    this.MovieView = MovieComponent.embed(this.span, this.state);
    MovieAction.findById(this.props.params.id);

    MovieStore.addChangeListener(this.setMovie);
    ReviewStore.addChangeListener(this.setReview);

    this.MovieView.ports.onClickBackButton.subscribe(this.backToScheduleView);
    this.MovieView.ports.onClickPointButton.subscribe(this.reviewMovie);
    this.MovieView.ports.onClickRemoveReviewButton.subscribe(this.removeReview);
  }

  componentWillUnmount() {
    MovieStore.removeChangeListener(this.setMovie);
    ReviewStore.removeChangeListener(this.setReview);
    this.MovieView.ports.onClickBackButton.unsubscribe(this.backToScheduleView);
    this.MovieView.ports.onClickPointButton.unsubscribe(this.reviewMovie);
    this.MovieView.ports.onClickRemoveReviewButton.unsubscribe(this.removeReview);

  }

  render() {
   return (
    <span ref={(span) => {
        this.span = span
      }}>
      </span>
   )
  }

  reviewMovie(review) {
    ReviewAction.reviewMovie(review);
  }

  removeReview({id}) {
    ReviewAction.removeReview(id);
  }

  backToScheduleView() {
    this.context.router.transitionTo(`/schedule`);
  }

  setMovie() {
    this.setState({
      movie: MovieStore.findById(this.props.params.id)
    });
  }

  setReview() {
    const review = ReviewStore.findById(this.props.params.id);
    this.setState({ review });
  }

}