import { Deck, Slide, Heading, Text, AnimatedProgress } from "spectacle";
import useWindowSize from "./useWindowSize";
import "./Slides.sass";
import swipeLeftImg from "./assets/swipe-left.gif";
import NavigationButtons from "./NavigationButtons";
import ShareButton from "./ShareButton";

const getImageUrl = (image) => `${process.env.PUBLIC_URL}/achievement_backgrounds/${image}.png`;

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
        className="slide slide--introduction"
      >
        <img src={getImageUrl("ADK_wrapped_background")} className="slide__bg" alt="Ilustrativní obrázek" />
        <AnimatedProgress className="slide__progress" />
        <Heading className="slide__heading">Uplynulá sezóna Ti přinesla mnohé zážitky...</Heading>
        <Text className="slide__text">My jsme jich tu pár shrnuli 😊</Text>
        <img src={swipeLeftImg} alt="Swajpni doleva" className="slide__swipe-left"/>
        <NavigationButtons />
      </Slide>
      {achievements.map((achievement) => (
        <Slide
          key={achievement.achievement_id}
          className="slide"
        >
          <img src={getImageUrl(achievement.achievement_image)} className="slide__bg" alt="Ilustrativní obrázek" />
          <AnimatedProgress className="slide__progress" />
          <Heading className="slide__heading">
            {achievement.achievement_name}
          </Heading>
          <Text className="slide__text">
            {achievement.achievement_description}
          </Text>
            <ShareButton />
          <NavigationButtons />
        </Slide>
      ))}
      <Slide
        key="conclusion"
        className="slide slide--conclusion"
      >
        <img src={getImageUrl("ADK_wrapped_background")} className="slide__bg" alt="Ilustrativní obrázek" />
        <AnimatedProgress className="slide__progress" />
        <Heading className="slide__heading">Děkujeme Ti, že debatuješ 💕</Heading>
        <NavigationButtons />
      </Slide>
    </Deck>
  );
}

export default Slides;
