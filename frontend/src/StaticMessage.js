import "./StaticMessage.sass";
import logo from "./assets/logo.svg";

function StaticMessage({ children }) {

  return (
    <div className="static-message">
      <img src={logo} alt="Logo ADK" className="static-message__logo" />
      {children}
    </div>
  );
}

export default StaticMessage;
