import { Movie } from '../model/Movie';

export type StoreMovieType = 'StoreMovie';
export const StoreMovieType: StoreMovieType = 'StoreMovie';
export type StoreMovie = {
  type: StoreMovieType
  movie: Movie
}

export type MoviePayload = StoreMovie;