const MovieVOCache = new Map()

export class Movie {
  constructor(props) {
    const {id, title, thumbnail_url, detail_url, story} = props;
    this.id = id;
    this.title = title;
    this.thumbnailUrl = thumbnail_url || "";
    this.detailUrl = detail_url || "";
    this.story = story
  }
  id: string
  title: string
  thumbnailUrl: string
  detailUrl: string
  story: string

  static create(props) {
    const movieVo = MovieVOCache.get(props.id);
    if(movieVo) {
      props.thumbnail_url = movieVo.thumbnailUrl;
      props.detail_url = movieVo.detailUrl;
      return new Movie(props)
    }
    return new Movie(props)
  }
}

export class MovieVO {
  constructor(props) {
    const {id, title, thumbnail_url, detail_url, story} = props;
    this.id = id;
    this.title = title;
    this.thumbnailUrl = thumbnail_url;
    this.detailUrl = detail_url;
    this.story = story
  }
  id: string
  title: string
  thumbnailUrl: string
  detailUrl: string
  story: string

  static getByCache(id) {
    return MovieVOCache.get(id)
  }

  static create(props) {
    const movie = MovieVOCache.get(props.id);
    if (movie) {
      return movie
    } else {
      const createdMovie = new MovieVO(props)
      MovieVOCache.set(createdMovie.id, createdMovie)
      return createdMovie
    }
  }
}