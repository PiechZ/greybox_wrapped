// src/Slides.js
import React, { useEffect, useState, useRef } from 'react';
import Reveal from 'reveal.js';
import 'reveal.js/dist/reveal.css';
import 'reveal.js/dist/theme/solarized.css';
import AchievementSlide from './AchievementSlide';

const Slides = ({ personId }) => {
  const [achievements, setAchievements] = useState([]);
  const revealRef = useRef(null);

  useEffect(() => {
    const fetchAchievements = async () => {
      const response = await fetch(`http://localhost:8765/achievements/${personId}`);
      const data = await response.json();
      setAchievements(data);
      initializeReveal();
    };

    const initializeReveal = () => {
      if (revealRef.current) {
        const revealInstance = new Reveal(revealRef.current);
        revealInstance.initialize();
      }
    };

    fetchAchievements();
  }, [personId]);

  return (
    <div className="reveal" ref={revealRef}>
      <div className="slides">
        <section><h1>Introduction Slide</h1></section>
        {achievements.map((achievement) => (
          <AchievementSlide key={achievement.achievement_id} {...achievement} />
        ))}
        <section><h2>Conclusion Slide</h2></section>
      </div>
    </div>
  );
};

export default Slides;
