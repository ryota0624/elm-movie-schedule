export class Review {
  constructor(props) {
    this.id = props.id;
    this.point = props.point;
  }

  static create(id, point) {
    return new Review({ id, point });
  }
}