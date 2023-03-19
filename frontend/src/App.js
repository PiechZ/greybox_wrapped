import React, { useState, useEffect } from 'react';
// eslint-disable-next-line
import { Deck, Slide, Heading, Text, SlideLayout, Progress, AnimatedProgress } from "spectacle";

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
  // TODO: get personId from URL
  const personId = 932;
  // TODO: use personId as argument here?
  useEffect (() => {
    fetch(apiServer + `/achievements/${personId}`)
      .then(response => response.json())
      .then(data => {
        setAchievements(data);
        console.log(data);
      });
  }, (error) => {
    console.log(error);
  });
  // FIXME: This retrieves the backend data, but it doesn't add the slides!

  return (
    <Deck theme={theme}>
      <Slide>
        <AnimatedProgress left={progressBarPosition} />
        <Heading>Uplynulá sezóna Ti přinesla mnohé zážitky...</Heading>
        <Text>My jsme jich tu pár shrnuli :)</Text>
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

export default App;
