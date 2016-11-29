import { Component, PropTypes } from 'react';
import * as React from 'react'
import ScheduleStore from '../../store/ScheduleStore';
import ScheduleAction from '../../action/ScheduleAction';

import { Schedule } from '../../model/Schedule';

const {ScheduleComponent} = require('./ScheduleComponent.elm');

type ScheduleContainerState = {
  schedule?: Schedule
}

export default class ScheduleViewContainer extends Component<any, ScheduleContainerState> {
  static contextTypes = {
    router: PropTypes.object.isRequired
  }
  context: {
    router: any
  }
  ScheduleView: any
  span: any
  constructor(props, context) {
    super(props, context);
    this.state = { schedule: ScheduleStore.getOne() };
  }
  componentDidUpdate(prevProps, prevState) {
    this.ScheduleView.ports.schedule.send(this.state.schedule);
  }

  componentDidMount() {
    this.onClickMovie = this.onClickMovie.bind(this);
    this.setSchedule = this.setSchedule.bind(this);

    this.ScheduleView = ScheduleComponent.embed(this.span, this.state);
    this.ScheduleView.ports.onClickMovie.subscribe(this.onClickMovie);
    this.ScheduleView.ports.onChangePreviewTime.subscribe(time => {
      ScheduleAction.getByTime(time);
    });
    
    ScheduleAction.getOne();
    ScheduleStore.addChangeListener(this.setSchedule);
  }

  setSchedule() {
    this.setState({
      schedule: ScheduleStore.getOne()
    });
  }

  onClickMovie(movie) {
    this.context.router.transitionTo(`/movie/${movie.id}`);
  }

  componentWillUnmount() {
    this.ScheduleView.ports.onClickMovie.unsubscribe(this.onClickMovie);
    ScheduleStore.removeChangeListener(this.setSchedule);
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