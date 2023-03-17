import React from "react";
// eslint-disable-next-line
import { Deck, Slide, Heading, Text, SlideLayout, Progress, AnimatedProgress } from "spectacle";

const getImageUrl = (image) => {
  return `url(${process.env.PUBLIC_URL}/achievement_backgrounds/${image}.png)`;
};

var Achievements = [
  {
    id: "Gastarbeiter/932/2",
    name: "Gastarbeiter",
    description: "Debatoval/a jsi za týmy z alespoň dvou různých klubů!",
    // image: "url(" + process.env.PUBLIC_URL + '/achievement_backgrounds/gastarbeiter.png)',
    image: getImageUrl("gastarbeiter"),
  },
  {
    id: "Lingvista/932/2",
    name: "Lingvista",
    description: "Mluvil/a jsi tento rok v debatách v alespoň dvou různých jazycích!",
    // image: "url(" + process.env.PUBLIC_URL + '/achievement_backgrounds/linguist.png)',
    image: getImageUrl("linguist"),
  },
  {
    id: "Nemesis/932/2",
    name: "Nemesis",
    description: "Tvým úhlavním soupeřem byl tento rok... Nicolas Ivanov!",
    // image: "url(" + process.env.PUBLIC_URL + '/achievement_backgrounds/nemesis.png)',,
    image: getImageUrl("nemesis"),
  }
];

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
  return (
    <Deck theme={theme}>
      <Slide>
        <AnimatedProgress left={progressBarPosition} />
        <Heading>Uplynulá sezóna Ti přinesla mnohé zážitky...</Heading>
        <Text>My jsme jich tu pár shrnuli :)</Text>
      </Slide>
      {Achievements.map((achievement) => (
        <Slide
          backgroundImage={achievement.image}
          backgroundSize="cover"
          backgroundPosition="center"
          backgroundRepeat="no-repeat"
        >
          <AnimatedProgress left={progressBarPosition} />
          <Heading backgroundColor="black" opacity="0.6">{achievement.name}</Heading>
          <Text backgroundColor="black" opacity="0.6">{achievement.description}</Text>
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
