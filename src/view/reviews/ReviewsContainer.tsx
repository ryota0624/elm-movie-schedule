import * as React from 'react';
import MovieStore from '../../store/MovieStore';
import ReviewStore from '../../store/ReviewStore';

import MovieAction from '../../action/MovieAction';
import ReviewAction from '../../action/ReviewAction';

const {ReviewsComponent} = require('./ReviewsComponent.elm');


export default class ReviewsContainer extends React.PureComponent<{}, {}> {
  span: any
  elmView: any
  componentDidMount() {
    const reviews = ReviewStore.findAll();
    const movies = MovieStore.findByIds(reviews.map(review => review.id));
    this.elmView = ReviewsComponent.embed(this.span, {
      movies,
      reviews
    });
    const reviewIds = reviews.map(review => review.id);
    MovieAction.findByIds(reviewIds);
  }

  render() {
    return (
      <span ref={(span) => {
        this.span = span;
      } }>
      </span>  
    )
  }

  setStateToElm() {
    const reviews = ReviewStore.findAll();
    const movies = MovieStore.findByIds(reviews.map(review => review.id));
  }
}