import { Movie } from '../model/Movie';
import { MovieAdaptor } from '../adaptor/MovieAdaptor';

import Dexie from 'dexie';
function toMovie(json) {
  return Movie.create(
      {
        id: json.id,
        title: json.title,
        thumbnail_url: json.thumbnailUrl,
        detail_url: json.detailUrl,
        story: json.story
      }
    )
}
class MovieDB extends Dexie {
  movies: Dexie.Table<Movie, string>
  constructor(version) {
    super("Movie");
    this.version(version).stores({
      movies: "id,title,thumbnailUrl,detailUrl,story"
    });
  }

  store(movie: Movie): Promise<void> {
    return this.movies.add(movie) as any
  }

  findById(id) {
    return this.movies.get(id).then(json => {
      if (json) {
        return toMovie(json)
      }
      return null
    });
  }
  findAll() {
    return this.movies.toArray().then(arr => arr.map(json => toMovie(json)))
  }

  findByIds(ids: string[]) {
    return this.movies.where('id').equals(ids).toArray();
  }
  
}

const db = new MovieDB(1);
export const movieDB = db;

export class MovieGateway implements MovieAdaptor {
  findById(id: string): Promise<Movie> {
    return ((db.findById(id)
      .then(movie => {
      if (movie instanceof Movie) {
        return movie
      }
      return (window as any).fetch("/movie/" + id)
      .then(response => response.json())
        .then(json => Movie.create(json))
        .then(movie => {
          db.store(movie);
          return movie;
      })
    })) as any)
  }

  findByIds(ids: string[]): Promise<Movie[]> {
    const movies = db.findByIds(ids).then(movies => {
      const findedIds = movies.map(a => a.id);
      const notFindedIds = ids.filter(id => movies.some(m => m.id === id));
      if (ids.length === findedIds.length) {
        return movies;
      }
      const promises = notFindedIds.map(id => {
        return (window as any).fetch("/movie/" + id)
          .then(response => response.json())
          .then(json => Movie.create(json))
      });
      return Promise.all(promises).then(moviesFromAPI => {
        return moviesFromAPI.concat(movies);
      });
    })

    return movies as any
  }
}

const instance = new MovieGateway();
export default instance;