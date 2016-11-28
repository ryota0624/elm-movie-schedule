import {ScheduleStore as ScheduleStoreWorker} from './ScheduleStore.elm';

export const scheduleStoreWorker = ScheduleStoreWorker.worker({
  schedule: {
    date: "",
    movies: []
  }
})

export class ScheduleStore {
  constructor(pushStatePort, dispatchers) {
    this.port = pushStatePort;
    this.dispatchers = dispatchers;
    this.subscribers = [];
    this.state = {
      schedule: {
        date: "",
        movies: []
      }
    }
    this._subscribePort()
  }

  _subscribePort() {
    this.subscribers.filter(a => a);
    this.port.subscribe(state => {
      this.state = state;
      this.subscribers.forEach(fun => fun())
    });
  }

  on(fn) {
    this.subscribers.push(fn);
  }

  rm(rmfn) {
    this.subscribers = this.subscribers.filter(fn => fn !== rmfn)
  }

  getOne() {
    return this.state.schedule
  }
}
const instance = new ScheduleStore(scheduleStoreWorker.ports.pushState, scheduleStoreWorker.ports);
export default instance