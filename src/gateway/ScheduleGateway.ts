import { Schedule } from '../model/Schedule';
import { SchduleAdaptor } from '../adaptor/ScheduleAdaptor';
const cache = new Map();

export class ScheduleGateway implements SchduleAdaptor {
  getOne() {
    return (window as any).fetch("/schedule")
    .then(response => response.json())
    .then(json => new Schedule(json)).then(schedule => {
      cache.set(schedule.date, schedule);
      return schedule
    })
  }

  getByTime(time) {
    return (window as any).fetch("/schedule/" + Math.floor(time / 1000))
    .then(response => response.json())
    .then(json => new Schedule(json))    
    .then(json => new Schedule(json)).then(schedule => {
      cache.set(schedule.date, schedule);
      return schedule
    })
  }
}

const instance = new ScheduleGateway();
export default instance