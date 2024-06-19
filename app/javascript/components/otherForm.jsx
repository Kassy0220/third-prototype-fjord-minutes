import React, { useState, useEffect } from "react";
import useSWR, { mutate } from "swr";
import fetcher from "../fetcher";

export default function OtherForm({ minute_id }) {
    const { data, error, isLoading } = useSWR(`/api/minutes/${minute_id}`, fetcher);

    if (error) return <div>エラーが発生しました！</div>;
    if (isLoading) return <div>読み込み中です...</div>;

    const other = data.other;
    console.log(`Otherがレンダーされました!${data.other}`);
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
        console.log(inputValue)
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
                mutate(`/api/minutes/${minuteId}`);
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