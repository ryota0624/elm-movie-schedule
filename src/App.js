import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';
import { Match as Route, HashRouter as Router, Link } from 'react-router';
import ScheduleContainer from './schedule/ScheduleContainer';

class App extends Component {
  render() {
    return (
      <Router>
      <div className="App">
        <div className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h2>Welcome to React</h2><Link to='/'>/</Link><Link to='/schedule'>schedule</Link>
        </div>
        <p className="App-intro">
          <Route exactly pattern='/' component={() => <span>To getstarted, edit <code>src/App.js</code> and save to reload. </span>} />
          <Route exactly pattern='/schedule' component={ScheduleContainer} />
        </p>
      </div>
      </Router>
    );
  }
}

export default App;
