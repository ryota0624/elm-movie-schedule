import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import './index.css';
import ReviewStore from './store/ReviewStore';
import MovieStore from './store/MovieStore';

import ReviewGateway from './gateway/ReviewGateway';
import { movieDB } from './gateway/MovieGateway';

function init() {
  return ReviewGateway.findAll().then(arr => {
    ReviewStore.bulkStore(arr)
  }).then(() => {
    return movieDB.findAll().then(arr => {
      MovieStore.bulkStore(arr);
    })
  })
}

init().then(() => {
  ReactDOM.render(
    <App />,
    document.getElementById('root')
  );
})
