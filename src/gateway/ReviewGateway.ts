import Dexie from 'dexie';
import { Review } from '../model/Review';
import { ReviewAdaptor } from '../adaptor/ReviewAdaptor';

export class ReviewGateway extends Dexie implements ReviewAdaptor {
  reviews: Dexie.Table<Review, string>
  constructor(version) {
    super('Review');
    this.version(version).stores({
      reviews: "id,point"
    });
  }

  remove(id: string) {
    return this.reviews.delete(id) as any
  }

  store(review: Review): Promise<void> {
    return this.reviews.add(review) as any
  }

  findById(id) {
    return this.reviews.get(id).then(json => new Review(json));
  }

  findAll() {
    return this.reviews.toArray().then(arr => arr.map(json => new Review(json)));
  }
}
const instance = new ReviewGateway(1)
export default instance;