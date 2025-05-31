import React, { useState, useEffect } from "react";
import {
  BrowserRouter as Router,
  Routes,
  Route,
  useParams,
} from "react-router-dom";
import Slides from "./Slides";
import StaticMessage from "./StaticMessage";
import * as duckdb from '@duckdb/duckdb-wasm';

const apiServer = "/api";

function withAchievements(WrappedComponent, fetchAchievements) {
  return function () {
    const params = useParams();
    const [achievements, setAchievements] = useState({
      loading: true,
      data: null,
    });

    useEffect(() => {
      fetchAchievements(params)
        .then((data) => {
          setAchievements({
            loading: false,
            data,
          });
        })
        .catch(() => {
          setAchievements({
            loading: false,
            data: null,
          });
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

async function initializeDuckDB() {
  const JSDELIVR_BUNDLES = duckdb.getJsDelivrBundles();
  const bundle = await duckdb.selectBundle(JSDELIVR_BUNDLES);

  const worker_url = URL.createObjectURL(
    new Blob([`importScripts("${bundle.mainWorker}");`], { type: 'text/javascript' })
  );

  const worker = new Worker(worker_url);
  const logger = new duckdb.ConsoleLogger();
  const db = new duckdb.AsyncDuckDB(logger, worker);

  await db.instantiate(bundle.mainModule, bundle.pthreadWorker);
  URL.revokeObjectURL(worker_url);

  const connection = await db.connect();

  console.log('Fetching database file...');
  const response = await fetch('/adk_wrapped.db');
  const buffer = await response.arrayBuffer();
  console.log('Buffer fetched:', buffer);

  console.log('Attempting to register file buffer...');
  try {
    await db.registerFileBuffer('adk_wrapped.db', buffer);
    console.log('File buffer registered successfully.');
  } catch (error) {
    console.error('Error during registerFileBuffer:', error);
    console.log('Attempting alternative method: ATTACH DATABASE');
    try {
      await connection.query("ATTACH DATABASE '/adk_wrapped.db' AS adk_wrapped;");
      console.log('Database attached successfully.');
    } catch (attachError) {
      console.error('Error during ATTACH DATABASE:', attachError);
    }
  }

  // Query the database
  const result = await connection.query("SELECT * FROM adk_wrapped.main.final__current_achievements ORDER BY achievement_priority DESC");
  console.log(result.toArray());

  connection.close();
  db.terminate();
}

initializeDuckDB();

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/slides/:person_id" element={<PersonIdSlides />} />
        <Route path="/link/:id_hash" element={<IdHashSlides />} />
        <Route
          path="/"
          element={
            <StaticMessage>
              K této aplikaci není možné přistoupit napřímo. Běžte prosím na{" "}
              <a href="https://www.debatovani.cz/greybox/registrace">
                Greybox 2.0
              </a>{" "}
              a klikněte na svůj Wrapped odkaz v levém menu.
            </StaticMessage>
          }
        />
      </Routes>
    </Router>
  );
}

export default App;
