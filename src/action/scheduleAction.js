import dispatcher from '../dispatcher/dispatcher'

export class ScheduleAction {
  constructor(dispatcher) {
    this.dispatcher = dispatcher
  }

  static constants = {
    store: "scheduleActionStore"
  }

  get() {
    fetch("/schedule")
    .then(response => response.json())
    .then(json => {
      this.dispatcher.dispatch({
        type: ScheduleAction.constants.store,
        schedule: json
      })
    })
  }
}

const instance = new ScheduleAction(dispatcher);
export default instance