import {MovieVO} from './Movie'
export class Schedule {
  date: number
  movies: MovieVO[]
  constructor(props) {
    this.date = props.date
    this.movies = props.movies.map(movieJSON => {
      const {id, title, thumbnail_url, detail_url} = movieJSON;
      return MovieVO.create({
        id,
        title,
        thumbnail_url,
        detail_url,
        story: ""
      })
    })
  }
}

