import { PureComponent, PropTypes } from 'react';
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

export default class MovieViewContainer extends PureComponent<MovieViewContainerProps, {}> {
  static contextTypes = {
    router: PropTypes.object.isRequired
  }
  span: any
  MovieView: any
  context: { router: any }
  constructor(props, context) {
    super(props, context)
    this.reviewMovie = this.reviewMovie.bind(this);
    this.backToScheduleView = this.backToScheduleView.bind(this);
    this.removeReview = this.removeReview.bind(this);
    this.setStateToElm = this.setStateToElm.bind(this);
  }

  componentDidMount() {
    this.MovieView = MovieComponent.embed(this.span, {
      movie: MovieStore.findById(this.props.params.id),
      review: ReviewStore.findById(this.props.params.id)
    });
    MovieAction.findById(this.props.params.id);

    MovieStore.addChangeListener(this.setStateToElm);
    ReviewStore.addChangeListener(this.setStateToElm);

    this.MovieView.ports.onClickBackButton.subscribe(this.backToScheduleView);
    this.MovieView.ports.onClickPointButton.subscribe(this.reviewMovie);
    this.MovieView.ports.onClickRemoveReviewButton.subscribe(this.removeReview);
  }

  componentWillUnmount() {
    MovieStore.removeChangeListener(this.setStateToElm);
    ReviewStore.removeChangeListener(this.setStateToElm);
    this.MovieView.ports.onClickBackButton.unsubscribe(this.backToScheduleView);
    this.MovieView.ports.onClickPointButton.unsubscribe(this.reviewMovie);
    this.MovieView.ports.onClickRemoveReviewButton.unsubscribe(this.removeReview);

  }

  render() {
   return (
    <span ref={(span) => {
       this.span = span;
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

  setStateToElm() {
    const review = ReviewStore.findById(this.props.params.id);
    const movie = MovieStore.findById(this.props.params.id);
    this.MovieView.ports.state.send({ review, movie });
  }
}