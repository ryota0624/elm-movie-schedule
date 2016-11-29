import * as flux from 'flux';
import { MoviePayload } from './MoviePayload';
import { SchedulePayload } from './SchedulePayload';
import { ReviewPayload } from './ReviewPayload';


type BaseType = {
  type: "none"
}

export type ActionType =
  BaseType |
  MoviePayload |
  SchedulePayload |
  ReviewPayload


export class AppDispather extends flux.Dispatcher<ActionType> { }

const instance = new AppDispather();
export default instance;

