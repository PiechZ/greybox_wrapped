import React, { useState, useEffect } from "react";
import {
  BrowserRouter as Router,
  Routes,
  Route,
  useParams,
} from "react-router-dom";
import Slides from "./Slides";

const apiServer = "/api";

function withAchievements(WrappedComponent, fetchAchievements) {
  return function () {
    const params = useParams();
    const [achievements, setAchievements] = useState([]);

    useEffect(() => {
      fetchAchievements(params)
        .then((data) => {
          setAchievements(data);
          console.log(data);
        })
        .catch((error) => {
          console.log(error);
        });
    }, [params]);

    return <WrappedComponent achievements={achievements} />;
  };
}

const PersonIdSlides = withAchievements(Slides, ({ person_id }) =>
  fetch(apiServer + `/achievements/${person_id}`).then((response) =>
    response.json()
  )
);

const IdHashSlides = withAchievements(Slides, ({ id_hash }) =>
  fetch(apiServer + `/link/${id_hash}`).then((response) => response.json())
);

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/slides/:person_id" element={<PersonIdSlides />} />
        <Route path="/link/:id_hash" element={<IdHashSlides />} />
        <Route
          path="/"
          element={
            <div>
              This app cannot be accessed directly. Please go back to{" "}
              <a href="https://www.debatovani.cz/greybox/registrace">
                Greybox 2.0
              </a>{" "}
              and follow your specific link.
            </div>
          }
        />
      </Routes>
    </Router>
  );
}

export default App;
