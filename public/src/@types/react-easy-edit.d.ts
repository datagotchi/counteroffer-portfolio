// react-easy-edit.d.ts

declare module "react-easy-edit" {
  import * as React from "react";

  // Define the interface for the component props
  export interface EasyEditProps {
    type: "text" | "textarea" | "number" | "date" | "time" | "select";
    onSave: (value: any) => void;
    onCancel?: () => void;
    value: any;
    // Further props are defined below...
    inputAttributes?: any;
  }

  // Declare the main component as a React Functional Component
  const EasyEdit: React.FC<EasyEditProps>;
  export default EasyEdit;

  // Declare the Types enum/object that is also exported
  export const Types: {
    TEXT: "text";
    TEXTAREA: "textarea";
    NUMBER: "number";
    DATE: "date";
    TIME: "time";
    SELECT: "select";
  };
}
