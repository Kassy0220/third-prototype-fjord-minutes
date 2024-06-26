import React, { useState, useEffect } from "react"
import dayjs from "dayjs";
import consumer from "../channels/consumer";

export default function NextDateForm({ minute_id, next_date }) {
    const [nextDate, setNextDate] = useState(next_date)
    const [isEditing, setIsEditing] = useState(false)

    useEffect(() => {
        consumer.subscriptions.create({ channel: 'MinuteChannel', id: minute_id }, {
            received(data) {
                if ('minute' in data.body) setNextDate(data.body.minute.next_date);
            }
        });
    }, [minute_id]);

    return (
        <div id="meeting_date_time">
            <div id="meeting_date">
                {isEditing ? <DateForm date={nextDate} setIsEditing={setIsEditing} minuteId={minute_id} /> : <MeetingDate date={nextDate} setIsEditing={setIsEditing} />}
            </div>
            <div id="meeting_time">
                <div>昼の部：15:00-16:00</div>
                <div>夜の部：22:00-23:00</div>
            </div>
        </div>
    )
}

function DateForm({ date, setIsEditing, minuteId }) {
    const [inputValue, setInputValue] = useState(date)

    const handleInput = (e) => {
        setInputValue(e.target.value);
    }

    const handleClick = async function(e) {
        e.preventDefault();

        const parameter = { minute: { next_date: inputValue } };
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
                setIsEditing(false);
            } else {
                throw Error(response.statusText);
            }
        } catch (e) {
            console.log(e);
        }
    }

    return (
        <div id="meeting_date_form">
            <input type="date" value={inputValue} onChange={handleInput} />
            <button onClick={handleClick}>更新</button>
        </div>
    )
}

function MeetingDate({ date, setIsEditing }) {
    const formatted_date = dayjs(date).format('YYYY年MM月DD日 (水)')

    return (
        <>
            <div>
                {formatted_date}
                <button onClick={() => {
                    setIsEditing(true)
                }}>
                    編集
                </button>
            </div>
        </>
    )
}
