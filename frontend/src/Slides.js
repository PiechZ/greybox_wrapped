import { Deck, Slide, Heading, Text, AnimatedProgress } from "spectacle";
import useWindowSize from "./useWindowSize";
import "./Slides.sass";
import swipeLeftImg from "./assets/swipe-left.gif";
import NavigationButtons from "./NavigationButtons";
import ShareButton from "./ShareButton";

const getImageUrl = (image) => `${process.env.PUBLIC_URL}/achievement_backgrounds/${image}.png`;

function Slides({ achievements: { loading, data } }) {
  const windowSize = useWindowSize();

  const theme = {
    size: {
      width: `${windowSize.width}px`,
      height: `${windowSize.height}px`
    },
  };

  if (loading) {
      return <div>Načítání...</div>;
  }

  if (!Array.isArray(data)) {
      return <div>Zde se bohužel něco pokazilo. Prosím, zkuste to jindy.</div>;
  }

  if (!data.length) {
      return <div>Bohužel pro Vás žádné achievementy nemáme 😢. Aplikace je zatím v první fázi testování, budeme doplňovat další achievementy postupně. Zkuste to třeba příští rok.</div>;
  }

  return (
    <Deck theme={theme} className="deck">
      <Slide
        key="introduction"
        backgroundImage={`url(${getImageUrl("ADK_wrapped_background")})`}
        className="slide slide--introduction"
      >
        <img src={getImageUrl("ADK_wrapped_background")} className="slide__bg" alt="Ilustrativní obrázek" />
        <AnimatedProgress className="slide__progress" />
        <Heading className="slide__heading">Uplynulá sezóna Ti přinesla mnohé zážitky...</Heading>
        <Text className="slide__text">My jsme jich tu pár shrnuli 😊</Text>
        <img src={swipeLeftImg} alt="Swajpni doleva" className="slide__swipe-left"/>
        <NavigationButtons />
      </Slide>
      {data.map((achievement) => (
        <Slide
          key={achievement.achievement_id}
          backgroundImage={`url(${getImageUrl(achievement.achievement_image)})`}
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
        backgroundImage={`url(${getImageUrl("ADK_wrapped_background")})`}
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
