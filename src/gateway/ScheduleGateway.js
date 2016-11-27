import {Schedule} from '../model/Schedule';
const cache = new Map();

export class ScheduleGateway {
  getOne() {
    return fetch("/schedule")
    .then(response => response.json())
    .then(json => new Schedule(json)).then(schedule => {
      cache.set(schedule.date, schedule);
      return schedule
    })
  }

  getByTime(time) {
    return fetch("/schedule/" + Math.floor(time / 1000))
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