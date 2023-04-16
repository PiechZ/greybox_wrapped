import { Deck, Slide, Heading, Text, AnimatedProgress } from "spectacle";
import useWindowSize from "./useWindowSize";
import "./Slides.sass";
import swipeLeftImg from "./assets/swipe-left.gif";

const getImageUrl = (image) => {
  return `url(${process.env.PUBLIC_URL}/achievement_backgrounds/${image}.png)`;
};

function Slides({ achievements }) {
  const windowSize = useWindowSize();

  const theme = {
    size: {
      width: `${windowSize.width}px`,
      height: `${windowSize.height}px`
    },
  };

  if (!achievements.length || achievements.length === 0) {
    return <div>Loading...</div>;
  }
  return (
    <Deck theme={theme} className="deck">
      <Slide
        key="introduction"
        backgroundImage={getImageUrl("ADK_wrapped_background")}
        className="slide slide--introduction"
      >
        <AnimatedProgress className="slide__progress" />
        <Heading className="slide__heading">Uplynulá sezóna Ti přinesla mnohé zážitky...</Heading>
        <Text className="slide__text">My jsme jich tu pár shrnuli 😊</Text>
        <img src={swipeLeftImg} alt="Swajpni doleva" className="slide__swipe-left"/>
      </Slide>
      {achievements.map((achievement) => (
        <Slide
          key={achievement.achievement_id}
          backgroundImage={getImageUrl(achievement.achievement_image)}
          className="slide"
        >
          <AnimatedProgress className="slide__progress" />
          <Heading className="slide__heading">
            {achievement.achievement_name}
          </Heading>
          <Text className="slide__text">
            {achievement.achievement_description}
          </Text>
        </Slide>
      ))}
      <Slide
        key="conclusion"
        backgroundImage={getImageUrl("ADK_wrapped_background")}
        className="slide slide--conclusion"
      >
        <AnimatedProgress className="slide__progress" />
        <Heading className="slide__heading">Děkujeme Ti, že debatuješ 💕</Heading>
      </Slide>
    </Deck>
  );
}

export default Slides;
