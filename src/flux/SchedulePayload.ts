import { Schedule } from '../model/Schedule';

export type StoreScheduleType = 'StoreScheduleType';
export const StoreScheduleType: StoreScheduleType = 'StoreScheduleType';
export type StoreSchedule = {
  type: StoreScheduleType
  schedule: Schedule
}

export type SchedulePayload = StoreSchedule;