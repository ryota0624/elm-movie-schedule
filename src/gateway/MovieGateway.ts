import { Movie } from '../model/Movie';
import { MovieAdaptor } from '../adaptor/MovieAdaptor';

export class MovieGateway implements MovieAdaptor {
  findById(id: string): Promise<Movie> {
    return (window as any).fetch("/movie/" + id)
    .then(response => response.json())
    .then(json => Movie.create(json))
  }
}

const instance = new MovieGateway();
export default instance;