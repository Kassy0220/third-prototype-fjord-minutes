import React, { StrictMode } from "react";
import { createRoot } from 'react-dom/client';

export function mountComponent(id_name, Component) {
    const element = document.getElementById(id_name)
    if (element === null) {
        return null;
    }

    const root = createRoot(element);
    const props = JSON.parse(element.getAttribute('data'));
    root.render(
        <StrictMode>
            <Component {...props} />
        </StrictMode>
    );
}