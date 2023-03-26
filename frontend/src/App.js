// src/App.js
import React from 'react';
import {
  BrowserRouter as Router,
  Route,
  Routes,
  useParams,
} from 'react-router-dom';
import './App.css';
import Slides from './Slides';

const SlidesRoute = () => {
  const { person_id } = useParams();
  return <Slides personId={person_id} />;
};

const App = () => {
  return (
    <Router>
      <div className="App">
        <Routes>
          <Route path="/adk-wrapped/:person_id" element={<SlidesRoute />} />
        </Routes>
      </div>
    </Router>
  );
};

export default App;
