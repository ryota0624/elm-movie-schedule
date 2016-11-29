import MovieStore from '../store/MovieStore';
import {Movie} from '../model/Movie';
import dispather, { AppDispather } from '../flux/dispatcher';
import { StoreMovieType, StoreMoviesType } from '../flux/MoviePayload';

import MovieGateway from '../gateway/MovieGateway';
import { MovieAdaptor } from '../adaptor/MovieAdaptor';

export class MovieAction {
  constructor(
    private dispather: AppDispather,
    private movieGateway: MovieAdaptor
  ) { }

  findById(id) {
    this.movieGateway.findById(id)
      .then((movie: Movie) => this.dispather.dispatch({
        type: StoreMovieType,
        movie
      }));
  }

  findByIds(ids: string[]) {
    this.movieGateway.findByIds(ids).then(movies => {
      this.dispather.dispatch({
        type: StoreMoviesType,
        movies
      })
    });
  }
}
const instance = new MovieAction(dispather, MovieGateway);
export default instance