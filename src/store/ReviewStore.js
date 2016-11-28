export class ReviewStore {
  constructor() {
    this.subscribers = [];
    this.state = {
      reviews: []
    }
  }

  store(review) {
    this.state.reviews.push(review);
    this._subscribePort();
  }

  bulkStore(reviews) {
    this.state.reviews = this.state.reviews.concat(reviews);
    this._subscribePort();
  }

  _subscribePort() {
    this.subscribers.forEach(fun => fun())
  }

  on(fn) {
    this.subscribers.push(fn);
  }

  rm(rmfn) {
    this.subscribers = this.subscribers.filter(fn => fn !== rmfn)
  }

  findById(id) {
    return this.state.reviews.filter(review => review.id === id)[0] || null
  }
}
const instance = new ReviewStore();
export default instance