import {ReduceStore} from 'flux/utils';
import dispatcher from '../dispatcher/dispatcher';
import {ScheduleAction} from '../action/scheduleAction';
import {Schedule} from '../model/Schedule';
export class ScheduleStore extends ReduceStore {
  getInitialState() {
    return {
      movies: [],
      date: "date"
    }
  }

  reduce(state, action) {
    console.log(action)
    switch (action.type) {
      case ScheduleAction.constants.store:
        return new Schedule(action.schedule)
      default:
        return state
    }
  }
}

export const scheduleStore = new ScheduleStore(dispatcher)