import ReviewGateway from '../gateway/ReviewGateway';
import ReviewStore from '../store/ReviewStore';
import { Review } from '../model/Review';
import dispatcher, { AppDispather } from '../flux/dispatcher';
import { StoreReviewType, RemoveReviewType } from '../flux/ReviewPayload';

import { ReviewAdaptor } from '../adaptor/ReviewAdaptor';

export class ReviewAction {
  constructor(
    private dispatcher: AppDispather,
    private reviewAdaptor: ReviewAdaptor
  ) { }

  reviewMovie(review) {
    this.reviewAdaptor.store(review).then(() => {
      this.dispatcher.dispatch({
        type: StoreReviewType,
        review
      });
    });
  }

  removeReview(id: string) {
    this.reviewAdaptor.remove(id).then(() => {
      this.dispatcher.dispatch({
        type: RemoveReviewType,
        id
      });
    })
  }
}

const instance = new ReviewAction(dispatcher, ReviewGateway);

export default instance