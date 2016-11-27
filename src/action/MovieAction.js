import MovieStore from '../store/MovieStore';
import {Movie} from '../model/Movie';
export class MovieAction {
  constructor(movieStore) {
    this.movieStore = movieStore;
  }
  findById(id) {
    fetch("/movie/" + id)
    .then(response => response.json())
    .then(json => Movie.create(json))
    .then(movie => this.movieStore.dispatchers.storeFromPort.send(movie))
  }
}
const instance = new MovieAction(MovieStore);
export default instance