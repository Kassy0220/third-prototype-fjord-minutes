import React from 'react';
import useSWR from "swr";
import fetcher from '../fetcher';

export default function Topics({ minute_id }) {
    const { data, error, isLoading } = useSWR(`/api/minutes/${minute_id}/topics`, fetcher)

    if (error) return <div>エラーが発生しました！</div>
    if (isLoading) return <div>読み込み中です...</div>

    return (
        <ul>
            {data.map((topic) => <li key={topic.id}>{topic.content}</li>)}
        </ul>
    )
}
