import React, { useState, useEffect } from 'react';
import consumer from "../channels/consumer";

export default function Topics({ minute_id, minute_topics }) {
    const [topics, setTopics] = useState(minute_topics);

    useEffect(() => {
        consumer.subscriptions.create({ channel: 'MinuteChannel', id: minute_id }, {
            received(data) {
                if ('topics' in data.body) setTopics([...data.body.topics])
            }
        });
    }, [minute_id]);

    return (
        <ul>
            {topics.map((topic) => <li key={topic.id}>{topic.content}</li>)}
        </ul>
    )
}
