import { Movie } from '../model/Movie';
export interface MovieAdaptor {
  findById(id: string): Promise<Movie>
  findByIds(ids: string[]): Promise<Movie[]>
}