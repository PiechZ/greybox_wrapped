// src/AchievementSlide.js
import React from 'react';

const AchievementSlide = ({
  achievementId,
  achievementName,
  achievementDescription,
}) => (
  <section data-achievement-id={achievementId}>
    <h2>{achievementName}</h2>
    <p>{achievementDescription}</p>
  </section>
);

export default AchievementSlide;
