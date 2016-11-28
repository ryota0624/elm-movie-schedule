import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import './index.css';
import ReviewStore from './store/ReviewStore';
import ReviewGateway from './gateway/ReviewGateway';

function init() {
  return ReviewGateway.findAll().then(arr => {
    ReviewStore.bulkStore(arr)
  })
}

init().then(() => {
  ReactDOM.render(
    <App />,
    document.getElementById('root')
  );
})
