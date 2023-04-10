import { Deck, Slide, Heading, Text, AnimatedProgress } from "spectacle";

const getImageUrl = (image) => {
  return `url(${process.env.PUBLIC_URL}/achievement_backgrounds/${image}.png)`;
};

function Slides({ achievements }) {
  const progressBarPosition = "45%";

  const theme = {
    colors: {
      primary: "#fff",
      secondary: "#fff",
      tertiary: "#03A9FC",
    },
    shadows: {
      primary: "10px 5px 5px black",
      secondary: "10px 5px 5px black",
    },
  };

  if (!achievements.length || achievements.length === 0) {
    return <div>Loading...</div>;
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
          backgroundImage={getImageUrl(achievement.achievement_image)}
          backgroundSize="cover"
          backgroundPosition="center"
          backgroundRepeat="no-repeat"
        >
          <AnimatedProgress left={progressBarPosition} />
          <Heading backgroundColor="black" opacity="0.6">
            {achievement.achievement_name}
          </Heading>
          <Text backgroundColor="black" opacity="0.6">
            {achievement.achievement_description}
          </Text>
        </Slide>
      ))}
      <Slide>
        <AnimatedProgress left={progressBarPosition} />
        <Heading>Děkujeme Ti, že debatuješ 💕</Heading>
      </Slide>
    </Deck>
  );
}

export default Slides;