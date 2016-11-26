import React, {Component} from 'react';
import {Container} from 'flux/utils';
import {scheduleStore} from '../store/scheduleStore';
import elm from './elm/ScheduleComponent.elm';
import scheduleAction from '../action/scheduleAction';
import {WorkerPort} from './elm-worker/worker.elm';

const worker = WorkerPort.worker({
  schedule: { movies: [], date: "" }
})

class ScheduleView extends Component {
  static getStores() {
    return [scheduleStore]
  }

  static calculateState(prevState) {
    return {
      schedule: scheduleStore.getState()
    }
  }

  componentDidUpdate(prevProps, prevState) {
    this.ScheduleView.ports.schedule.send(this.state.schedule)
    worker.ports.storeFromPort.send(this.state.schedule)
  }

  componentDidMount() {
    this.onClickMovie = ((movie) => {
      console.log(movie)
    }).bind(this)
    scheduleAction.get()
    this.ScheduleView = elm.ScheduleComponent.embed(this.span, this.state.schedule)
    this.ScheduleView.ports.onClickMovie.subscribe(this.onClickMovie)
  }

  componentWillUnmount() {
    this.ScheduleView.ports.onClickMovie.unsubscribe(this.onClickMovie)
  }

  render() {
    return (
      <span>
     <span ref={(span) => {
        this.span = span
      }}>
      </span>
      </span>
    )
  }
}

const ScheduleViewContainer = Container.create(ScheduleView);
export default ScheduleViewContainer;