import ScheduleStore from '../store/ScheduleStore';
import ScheduleGateway from '../gateway/ScheduleGateway';
import {Schedule} from '../model/Schedule';
export class ScheduleAction {
  constructor(scheduleStore, scheduleAdaptor) {
    this.scheduleStore = scheduleStore;
    this.scheduleAdaptor = scheduleAdaptor;
  }
  getOne() {
    this.scheduleAdaptor.getOne()
    .then(schedule => this.scheduleStore.dispatchers.storeFromPort.send(schedule))
  }

  getByTime(time) {
    this.scheduleAdaptor.getByTime(time)
    .then(schedule => this.scheduleStore.dispatchers.storeFromPort.send(schedule))
  }
}
const instance = new ScheduleAction(ScheduleStore, ScheduleGateway);
export default instance