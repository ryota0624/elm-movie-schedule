import Dexie from 'dexie';
import {Review} from '../model/Review';

export class ReviewGateway extends Dexie {
  constructor(version) {
    super('Review');
    this.version(version).stores({
      reviews: "id,point"
    });
  }

  store(review) {
    return this.reviews.add(review);
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