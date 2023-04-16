import { Deck, Slide, Heading, Text, AnimatedProgress } from "spectacle";
import useWindowSize from "./useWindowSize";

const getImageUrl = (image) => {
  return `url(${process.env.PUBLIC_URL}/achievement_backgrounds/${image}.png)`;
};

function Slides({ achievements }) {
  const windowSize = useWindowSize();
  const minDimension = Math.min(windowSize.width, windowSize.height);
  const progressBarPosition = "45%";

  const theme = {
    colors: {
      primary: "#fff",  // default heading color
      secondary: "#fff",  // default paragraph color
      tertiary: "#03A9FC",  // default background color
    },
    shadows: {
      primary: "10px 5px 5px black",
      secondary: "10px 5px 5px black",
    },
    size: {
      width: `${minDimension}px`,
      height: `${minDimension}px`
    },
    // Scale font sizes with viewport
    fontSizes: {
      primary: "3em",  // doesn't work
      secondary: "2em",  // doesn't work
      header: "3.5em",
      paragraph: "1.5em",
      text: "1.5em",
    },
  };

  if (!achievements.length || achievements.length === 0) {
    return <div>Loading...</div>;
  }
  return (
    <Deck 
      theme={theme}
    >
      <Slide
        key="introduction"
        backgroundImage={getImageUrl("ADK_wrapped_background")}
        backgroundSize="cover"
        backgroundPosition="center"
        backgroundRepeat="no-repeat"
      >
        <AnimatedProgress left={progressBarPosition} />
        <Heading color="black" fontSize="header">Uplynulá sezóna Ti přinesla mnohé zážitky...</Heading>
        <Text color="black" fontSize="paragraph">My jsme jich tu pár shrnuli 😊</Text>
      </Slide>
      {achievements.map((achievement) => (
        <Slide
          key={achievement.achievement_id}
          backgroundImage={getImageUrl(achievement.achievement_image)}
          backgroundSize="cover"
          backgroundPosition="center"
          backgroundRepeat="no-repeat"
        >
          <AnimatedProgress left={progressBarPosition} />
          <Heading backgroundColor="black" opacity="0.6" fontSize="header">
            {achievement.achievement_name}
          </Heading>
          <Text backgroundColor="black" opacity="0.6" fontSize="paragraph">
            {achievement.achievement_description}
          </Text>
        </Slide>
      ))}
      <Slide
        key="conclusion"
        backgroundImage={getImageUrl("ADK_wrapped_background")}
        backgroundSize="cover"
        backgroundPosition="center"
        backgroundRepeat="no-repeat"
      >
        <AnimatedProgress left={progressBarPosition} />
        <Heading color="black" fontSize="header">Děkujeme Ti, že debatuješ 💕</Heading>
      </Slide>
    </Deck>
  );
}

export default Slides;
