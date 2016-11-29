import { Movie } from '../model/Movie';

export type StoreMovieType = 'StoreMovie';
export const StoreMovieType: StoreMovieType = 'StoreMovie';
export type StoreMovie = {
  type: StoreMovieType
  movie: Movie
}

export type StoreMoviesType = 'StoreMoviesType';
export const StoreMoviesType = 'StoreMoviesType';
export type StoreMovies = {
  type: StoreMoviesType
  movies: Movie[]
}

export type MoviePayload = StoreMovie | StoreMovies;