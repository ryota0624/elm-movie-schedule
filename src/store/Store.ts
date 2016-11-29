import { EventEmitter } from 'events';

import * as flux from 'flux'

const CHANGE_EVENT = 'change',
  SELECT_EVENT = 'select',
  SERVER_ERROR_EVENT = 'server_error',
  SERVER_OK_EVENT = 'server_ok';

export abstract class BaseStore<T> extends EventEmitter {
  constructor(dispatcher: flux.Dispatcher<T>) {
    super();
    this.setMaxListeners(30);
    dispatcher.register(this.dispatchHandler.bind(this));
  }

  abstract dispatchHandler(action: T): void;
  addChangeListener(callback) {
        this.on(CHANGE_EVENT, callback);
      }
  
      removeChangeListener(callback) {
        this.removeListener(CHANGE_EVENT, callback);
      }
  
    emitChange() {
         this.emit(CHANGE_EVENT);
    }
  
         addSelectListener(callback) {
         this.on(SELECT_EVENT, callback);
         }
  

       removeSelectListener(callback) {
         this.removeListener(SELECT_EVENT, callback);
       }
  
        addServerErrorListener(callback) {
         this.on(SERVER_ERROR_EVENT, callback);
      }

      removeServerErrorListener(callback) {
        this.removeListener(SERVER_ERROR_EVENT, callback);
      }

      emitServerError() {
        this.emit(SERVER_ERROR_EVENT);
      }

      addServerOkListener(callback) {
        this.on(SERVER_OK_EVENT, callback);
      }

      removeServerOkListener(callback) {
        this.removeListener(SERVER_OK_EVENT, callback);
      }

      emitServerOk() {
        this.emit(SERVER_OK_EVENT);
      }
  
  
}