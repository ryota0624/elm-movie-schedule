import {MovieStore as MovieStoreWorker} from './MovieStore.elm';

export const movieStoreWorker = MovieStoreWorker.worker({
  movies: []
})

export class MovieStore {
  constructor(pushStatePort, dispatchers) {
    this.port = pushStatePort;
    this.dispatchers = dispatchers;
    this.subscribers = [];
    this.state = {
      movies: []
    }
    this._subscribePort()
  }

  _subscribePort() {
    this.subscribers.filter(a => a);
    this.port.subscribe(state => {
      this.state = state;
      this.subscribers.forEach(fun => fun())
    });
  }

  on(fn) {
    this.subscribers.push(fn);
  }

  rm(rmfn) {
    this.subscribers = this.subscribers.filter(fn => fn !== rmfn)
  }

  findById(id) {
    return this.state.movies.filter(movie => movie.id === id)[0] || null
  }
}
const instance = new MovieStore(movieStoreWorker.ports.pushState, movieStoreWorker.ports);
export default instance