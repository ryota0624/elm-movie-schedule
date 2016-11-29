import MovieStore from '../store/MovieStore';
import {Movie} from '../model/Movie';
import dispather, { AppDispather } from '../flux/dispatcher';
import { StoreMovieType } from '../flux/MoviePayload';

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
    }))
  }
}
const instance = new MovieAction(dispather, MovieGateway);
export default instance