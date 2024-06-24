import React, { useState, useEffect } from "react";
import consumer from "../channels/consumer";

export default function OtherForm({ minute_id, content }) {
    const [other, setOther] = useState(content ? content : '');

    useEffect(() => {
        consumer.subscriptions.create({ channel: 'MinuteChannel', id: minute_id }, {
            received(data) {
                if ('minute' in data.body) setOther(data.body.minute.other);
            }
        });
    }, [minute_id]);

    return (
        <>
            <TextArea
                other={other}
                minuteId={minute_id}
            />
        </>
    )
}

function TextArea({other, minuteId}) {
    const [inputValue, setInputValue] = useState(other);

    useEffect(() => {
        setInputValue(other);
    }, [other])

    const handleInput = (e) => {
        setInputValue(e.target.value);
    }

    const handleClick = async function(e) {
        e.preventDefault();
        const parameter = { minute: { other: inputValue } };
        const csrfToken = document.head.querySelector("meta[name=csrf-token]")?.content;

        try {
            const response = await fetch(`/api/minutes/${minuteId}`, {
                method: 'PATCH',
                body: JSON.stringify(parameter),
                headers: {
                    'Content-Type': 'application/json; charset=utf-8',
                    'X-CSRF-Token': csrfToken
                }
            })

            if (response.status === 200) {
                console.log('保存されました')
            } else {
                throw Error(response.statusText);
            }
        } catch (e) {
            console.log(e);
        }
    }

    return (
        <>
            <textarea
                id="other"
                value={inputValue}
                onChange={handleInput}
            />
            <button onClick={handleClick}>
                登録
            </button>
        </>
    )
}