// src/AchievementSlide.js
import React from 'react';

const AchievementSlide = ({
  achievement_id,
  achievement_name,
  achievement_description,
}) => (
  <section data-achievement-id={achievement_id} id={achievement_id}>
    <h2>{achievement_name}</h2>
    <p>{achievement_description}</p>
  </section>
);

export default AchievementSlide;
