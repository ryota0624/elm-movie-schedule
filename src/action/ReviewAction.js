import ReviewGateway from '../gateway/ReviewGateway';
import ReviewStore from '../store/ReviewStore';

export class ReviewAction {
  constructor(reviewAdaptor) {
    this.reviewAdaptor = reviewAdaptor;
  }
  reviewMovie(review) {
    this.reviewAdaptor.store(review).then(() => {
      ReviewStore.store(review);
    });
  }
}

const instance = new ReviewAction(ReviewGateway);

export default instance