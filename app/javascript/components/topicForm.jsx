import React, { useState } from 'react';
import { useSWRConfig } from "swr";

export default function TopicForm({ minute_id }) {
    const [content, setContent] = useState('');
    const { mutate } = useSWRConfig();
    const topicsURL = `/api/minutes/${minute_id}/topics`;

    const handleInputChange = (e) => {
        setContent(e.target.value);
    }

    const handleClick = async function(){
        const parameter = { topic: { content } };
        const csrfToken = document.head.querySelector("meta[name=csrf-token]")?.content;

        try {
            const response = await fetch(`/api/minutes/${minute_id}/topics`, {
                method: 'POST',
                body: JSON.stringify(parameter),
                headers: {
                    'Content-Type': 'application/json; charset=utf-8',
                    'X-CSRF-Token': csrfToken
                }
            })

            if (response.status === 201) {
                setContent('');
                mutate(topicsURL);
            }
            if (response.status !== 201) throw Error(response.statusText);
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
