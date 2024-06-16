import React, { useState } from 'react';

export default function TopicForm({ minuteId }) {
    const [content, setContent] = useState('');

    const handleInputChange = (e) => {
        setContent(e.target.value);
    }

    const handleClick = async function(){
        const parameter = { topic: { content } };
        const csrfToken = document.head.querySelector("meta[name=csrf-token]")?.content;

        try {
            const response = await fetch(`/api/minutes/${minuteId}/topics`, {
                method: 'POST',
                body: JSON.stringify(parameter),
                headers: {
                    'Content-Type': 'application/json; charset=utf-8',
                    'X-CSRF-Token': csrfToken
                }
            })

            if (response.status !== 200) throw Error(response.statusText);
        } catch (e) {
            console.log(e);
        }
    }


    return (
        <>
            <input type="text" value={content} onChange={handleInputChange}/>
            <button onClick={handleClick}>作成</button>
        </>
    )
}
