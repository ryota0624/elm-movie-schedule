import { Review } from '../model/Review';

export const StoreReviewType = 'StoreReviewType';
export type StoreReview = {
  type: 'StoreReviewType'
  review: Review
}

export const RemoveReviewType = 'RemoveReviewType';
export type RemoveReview = {
  type: 'RemoveReviewType'
  id: string
}


export type ReviewPayload = StoreReview | RemoveReview;