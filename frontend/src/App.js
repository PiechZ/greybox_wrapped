import React, { useState, useEffect } from 'react';
import { Deck, Slide, Heading, Text, AnimatedProgress } from "spectacle";

const getImageUrl = (image) => {
  return `url(${process.env.PUBLIC_URL}/achievement_backgrounds/${image}.png)`;
};

const apiServer = "http://localhost:8765"

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

function App() {
  const [achievements, setAchievements] = useState([]);
  const [personId, setPersonId] = useState(932);

  useEffect(() => {
    fetch(apiServer + `/achievements/${personId}`)
      .then(response => response.json())
      .then(data => {
        setAchievements(data);
        console.log(data);
      })
      .catch(error => {
        console.log("Error while fetching achievements");
        console.log(error);
      });
  }, []);

  return (
    <Deck theme={theme}>
      <Slide key="introduction">
        <AnimatedProgress left={progressBarPosition} />
        <Heading>Uplynulá sezóna Ti přinesla mnohé zážitky...</Heading>
        <Text>My jsme jich tu pár shrnuli :)</Text>
      </Slide>
      {achievements.length > 0 && achievements.map((achievement) => (
        // <React.Fragment key={achievement.achievement_id}>
          <Slide
            key={achievement.achievement_id}
            backgroundImage={getImageUrl(achievement.achievement_name)}
            backgroundSize="cover"
            backgroundPosition="center"
            backgroundRepeat="no-repeat"
          >
            <AnimatedProgress left={progressBarPosition} />
            <Heading backgroundColor="black" opacity="0.6">{achievement.achievement_name}</Heading>
            <Text backgroundColor="black" opacity="0.6">{achievement.achievement_description}</Text>
          </Slide>
        // </React.Fragment>
      ))}
      <Slide key="conclusion">
        <AnimatedProgress left={progressBarPosition} />
        <Heading>Děkujeme Ti, že debatuješ 💕</Heading>
      </Slide>
    </Deck>
  );
}

export default App;