import {BaseStore} from './Store';
import {MoviePayload, StoreMovieType, StoreMoviesType} from '../flux/MoviePayload';
import dispatcher, { AppDispather } from '../flux/dispatcher';
import { Movie } from '../model/Movie';

export class MovieStore extends BaseStore<MoviePayload> {
  state: ReadonlyArray<Movie> = Array();
  constructor(dispatcher: AppDispather) {
    super(dispatcher);
  }

  dispatchHandler(action: MoviePayload) {
    switch (action.type) {
      case StoreMovieType: 
        this.state = this.state.concat([action.movie]);
        this.emitChange();
        return
      case StoreMoviesType:
        this.bulkStore(action.movies);
        this.emitChange();
        return
    }

  }

  private bulkStore(movies: Movie[]) {
    this.state = this.state.concat(movies);
  }

  findByIds(ids: string[]) {
    return ids.map(id => this.findById(id)).filter(movie => movie !== null)
  }

  findById(id): Movie {
    return this.state.filter(movie => movie.id === id)[0] || null
  }
}
const instance = new MovieStore(dispatcher);
export default instance