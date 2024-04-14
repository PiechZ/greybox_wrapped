import {useContext, useState} from "react";
import {DeckContext} from "spectacle";
import "./NavigationButtons.sass";
import domtoimage from "dom-to-image";
import downloadIcon from "./assets/download.svg";
import spinner from "./assets/spinner.svg";

const excludeElements = ["slide__progress", "slide__nav-btn", "slide__share-btn"];
const fileName = "greybox-wrapped.jpeg";

function ShareButton() {
    const c = useContext(DeckContext);
    const [loading, setLoading] = useState(false);

    if (loading) {
        return (
            <img src={spinner} className="slide__share-btn slide__share-btn--loading" alt="Stahování se připravuje"/>
        );
    }

    return (
        <img className="slide__share-btn" onClick={() => {
            setLoading(true);
            domtoimage
                .toJpeg(c.slidePortalNode, {
                    filter: (item) => !excludeElements.some(r => item.classList?.contains(r)),
                })
                .then((dataUrl) => {
                    const link = document.createElement("a");
                    link.download = fileName;
                    link.href = dataUrl;
                    link.click();
                })
                .catch(() => alert("Omlouváme se, ale obrázek se nepodařilo stáhnout."))
                .finally(() => setLoading(false));
        }} alt="Stáhnout" src={downloadIcon}/>
    );
}

export default ShareButton;
