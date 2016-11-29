import { Review } from '../model/Review';
export interface ReviewAdaptor {
  store(review: Review): Promise<void>
  remove(id: string): Promise<void>
}
