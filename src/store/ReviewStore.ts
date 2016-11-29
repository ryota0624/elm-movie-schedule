import { BaseStore } from './Store';
import {ReviewPayload, StoreReviewType, RemoveReviewType} from '../flux/ReviewPayload';
import dispatcher, { AppDispather } from '../flux/dispatcher';
import { Review } from '../model/Review';

export class ReviewStore extends BaseStore<ReviewPayload> {
  state: ReadonlyArray<Review> = Array()
  constructor(dispatcher: AppDispather) {
    super(dispatcher);
  }

  dispatchHandler(action: ReviewPayload) {
    switch (action.type) {
      case StoreReviewType: 
        this.store(action.review);
        this.emitChange();
        return
      case RemoveReviewType:
        this.remove(action.id);
        this.emitChange();
        return
    }
  }

  private remove(id: string) {
    this.state = this.state.filter(review => review.id !== id);
  }

  private store(review) {
    this.bulkStore([review]);
  }

  private bulkStore(reviews: Review[]) {
    this.state = this.state.concat(reviews);
  }

  findById(id: string): Review {
    return this.state.filter(review => review.id === id)[0] || null
  }

  findAll(): Review[] {
    return [].concat(this.state)
  }
}
const instance = new ReviewStore(dispatcher);
export default instance