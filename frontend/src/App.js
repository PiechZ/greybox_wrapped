import React, { useState, useEffect } from 'react';
// eslint-disable-next-line
import { Deck, Slide, Heading, Text, SlideLayout, Progress, AnimatedProgress } from "spectacle";
import { BrowserRouter as Router, Routes, Route, useParams } from 'react-router-dom';

const getImageUrl = (image) => {
  return `url(${process.env.PUBLIC_URL}/achievement_backgrounds/${image}.png)`;
};

const apiServer = "/api"

const theme = {
  colors: {
    primary: "#fff",
    secondary: "#fff",
    tertiary: "#03A9FC",
  },
  shadows: {
    primary: "10px 5px 5px black",
    secondary: "10px 5px 5px black",
  }
}

const progressBarPosition = "45%"

function Slides() {
  const [achievements, setAchievements] = useState([]);
  const { person_id } = useParams();

  useEffect(() => {
    fetch(apiServer + `/achievements/${person_id}`)
      .then((response) => response.json())
      .then((data) => {
        setAchievements(data);
        console.log(data);
      });
  }, [person_id]);

  if (!achievements.length || achievements.length === 0) {
    return (
      <div>Loading...</div>
    )
  }
  return (
    <Deck theme={theme}>
      <Slide>
        <AnimatedProgress left={progressBarPosition} />
        <Heading>Uplynulá sezóna Ti přinesla mnohé zážitky...</Heading>
        <Text>My jsme jich tu pár shrnuli 🙃</Text>
      </Slide>
      {achievements.map((achievement) => (
        <Slide
          key={achievement.achievement_id}
          backgroundImage={getImageUrl(achievement.achievement_name.toLowerCase())}
          backgroundSize="cover"
          backgroundPosition="center"
          backgroundRepeat="no-repeat"
        >
          <AnimatedProgress left={progressBarPosition} />
          <Heading backgroundColor="black" opacity="0.6">{achievement.achievement_name}</Heading>
          <Text backgroundColor="black" opacity="0.6">{achievement.achievement_description}</Text>
        </Slide>
        ))}
      <Slide>
        <AnimatedProgress left={progressBarPosition} />
        <Heading>Děkujeme Ti, že debatuješ 💕</Heading>
      </Slide>
    </Deck>
  );
}

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/slides/:person_id" element={<Slides />} />
        <Route path="/" element={<div>This app cannot be accessed directly. Please go back to <a href="https://www.debatovani.cz/greybox/registrace">Greybox 2.0</a> and follow your specific link.</div>} />
      </Routes>
    </Router>
  );
}

export default App;
