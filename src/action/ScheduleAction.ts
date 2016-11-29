import ScheduleStore from '../store/ScheduleStore';
import ScheduleGateway from '../gateway/ScheduleGateway';
import { Schedule } from '../model/Schedule';
import dispather, { AppDispather } from '../flux/dispatcher';
import { StoreScheduleType } from '../flux/SchedulePayload';
import { SchduleAdaptor } from '../adaptor/ScheduleAdaptor';

export class ScheduleAction {
  constructor(
    private dispatcher: AppDispather,
    private scheduleAdaptor: SchduleAdaptor
  ) { }
  
  getOne() {
    this.scheduleAdaptor.getOne()
      .then(schedule => this.dispatcher.dispatch({
        type: StoreScheduleType,
        schedule
      }));
  }

  getByTime(time) {
    this.scheduleAdaptor.getByTime(time)
      .then(schedule => this.dispatcher.dispatch({ type: StoreScheduleType ,schedule }))
  }
}

const instance = new ScheduleAction(dispather, ScheduleGateway);
export default instance