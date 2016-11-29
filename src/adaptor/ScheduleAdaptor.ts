import { Schedule } from '../model/Schedule';

export interface SchduleAdaptor {
  getOne(): Promise<Schedule>
  getByTime(time: number): Promise<Schedule>
}