import {BaseStore} from './Store';
import dispatcher, { AppDispather, ActionType } from '../flux/dispatcher';
import { SchedulePayload, StoreScheduleType } from '../flux/SchedulePayload';
import { Schedule } from '../model/Schedule';
export class ScheduleStore extends BaseStore<SchedulePayload> {
  private state: Schedule | null = null
  constructor(dispatcher: AppDispather) {
    super(dispatcher);
  }

  getOne() : Schedule | null {
    return this.state
  }

  dispatchHandler(action: SchedulePayload) {
    switch (action.type) {
      case StoreScheduleType:
        this.state = action.schedule;
        this.emitChange()
    }
  }
}
const instance = new ScheduleStore(dispatcher);
export default instance