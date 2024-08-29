import React, { useState } from "react";

export default function Tooltip({ children, content }) {
    const [isShow, setIsShow] = useState(false)

    const handleMouseEnter = () => {
        setIsShow(true)
    }
    const handleMouseLeave = () => {
        setIsShow(false)
    }

    return (
        <div
            className="tooltip_container"
            onMouseEnter={handleMouseEnter}
            onMouseLeave={handleMouseLeave}
        >
            {isShow && <div className="tooltip">{content}</div>}
            <div>{children}</div>
        </div>
    )
}

