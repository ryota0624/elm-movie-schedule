import React, {Component, PropTypes} from 'react';
import {ScheduleComponent} from './ScheduleComponent.elm';
import ScheduleStore from '../../store/ScheduleStore';
import ScheduleAction from '../../action/ScheduleAction';

export default class ScheduleViewContainer extends Component {
  constructor(props, context) {
    super(props, context)
    this.state = {
      schedule: {
        date: "",
        movies: []
      }
    }
  }
  componentDidUpdate(prevProps, prevState) {
    this.ScheduleView.ports.schedule.send(this.state.schedule)
  }

  componentDidMount() {
    this.onClickMovie = this.onClickMovie.bind(this)
    this.setSchedule = this.setSchedule.bind(this)
    this.ScheduleView = ScheduleComponent.embed(this.span, this.state)
    this.ScheduleView.ports.onClickMovie.subscribe(this.onClickMovie)
    this.ScheduleView.ports.onChangePreviewTime.subscribe(time => {
      ScheduleAction.getByTime(time);
    })
    ScheduleAction.getOne()
    ScheduleStore.on(this.setSchedule)
  }

  setSchedule() {
    this.setState({
      schedule: ScheduleStore.getOne()
    })
  }

  onClickMovie(movie) {
    this.context.router.transitionTo(`/movie/${movie.id}`)
  }

  componentWillUnmount() {
    this.ScheduleView.ports.onClickMovie.unsubscribe(this.onClickMovie)
    ScheduleStore.rm(this.setSchedule)
  }

  render() {
    return (
        <span ref={(span) => {
          this.span = span
        }}>
        </span>
    )
  }
}

ScheduleViewContainer.contextTypes = {
  router: PropTypes.object.isRequired
}