import React, { Component } from 'react';
import './App.css';
import { Match as Route, HashRouter as Router, Link } from 'react-router';
import ScheduleContainer from './view/schedule/ScheduleContainer';
import MovieContainer from './view/movie/MovieContainer';

class App extends Component {
  render() {
    return (
      <Router>
      <div className="App">
        <div className="header">
          <Link to='/'>/</Link><Link to='/schedule'>schedule</Link>
        </div>
        <p className="main">
          <Route exactly pattern='/' component={() => <span>To getstarted, edit <code>src/App.js</code> and save to reload. </span>} />
          <Route exactly pattern='/movie/:id' component={MovieContainer} />
          <Route exactly pattern='/schedule' component={ScheduleContainer} />
        </p>
      </div>
      </Router>
    );
  }
}

export default App;
