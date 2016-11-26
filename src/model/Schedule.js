export class Schedule {
  constructor(props) {
    this.date = props.date
    this.movies = props.movies.map(movieJSON => {
      const {id, title, thumbnail_url, detail_url} = movieJSON;
      return {
        id,
        title,
        thumbnailUrl: thumbnail_url,
        detailUrl: detail_url
      }
    })
  }
}

