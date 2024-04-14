import {useContext} from "react";
import {DeckContext} from "spectacle";
import "./NavigationButtons.sass";

function NavigationButtons() {
    const c = useContext(DeckContext);

    return (
        <>
            {c.activeView.slideIndex !== 0 && <button className="slide__nav-btn slide__nav-btn--backward" onClick={() => c.stepBackward()}>⯇</button>}
            {c.activeView.slideIndex !== c.slideCount - 1 && <button className="slide__nav-btn slide__nav-btn--forward" onClick={() => c.stepForward()}>⯈</button>}
        </>
    );
}

export default NavigationButtons;
