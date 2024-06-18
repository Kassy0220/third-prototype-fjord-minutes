import React, { useState } from "react";
import useSWR, { mutate } from "swr";
import fetcher from "../fetcher";

export default function ReleaseNoteForm({ minute_id }) {
    const { data, error, isLoading } = useSWR(`/api/minutes/${minute_id}`, fetcher);
    const [isEditing, setIsEditing] = useState(false);

    if (error) return <div>エラーが発生しました！</div>;
    if (isLoading) return <div>読み込み中です...</div>;

    const releaseNote = data.release_note;
    return (
        <>
            {isEditing ?
                <EditForm
                    releaseNote={releaseNote}
                    setIsEditing={setIsEditing}
                    minuteId={minute_id}
                />
                :
                <ReleaseNote
                    releaseNote={releaseNote}
                    setIsEditing={setIsEditing}
                />
            }
        </>
    )
}

const EditForm = ({ releaseNote, setIsEditing, minuteId }) => {
    const [inputValue, setInputValue] = useState(releaseNote)
    const handleInput = (e) => {
        setInputValue(e.target.value);
    }

    const handleClick = async function(e) {
        e.preventDefault();
        const parameter = { minute: { release_note: inputValue } };
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
                mutate(`/api/minutes/${minuteId}`);
            } else {
                throw Error(response.statusText);
            }
        } catch (e) {
            console.log(e);
        }
    }

    return (
        <div>
            <input
                type="text"
                id="release_note"
                value={inputValue}
                onChange={handleInput}
            />
            <button onClick={handleClick}>更新</button>
        </div>
    )
}

const ReleaseNote = ({ releaseNote, setIsEditing }) => {
    const branchInfo = releaseNote ? `リリースノート : ${releaseNote}` : 'リリースノート : 未登録';
    return (
        <>
            <p>{branchInfo}</p>
            <div>
                <button onClick={() => {
                    setIsEditing(true)
                }}>
                    編集
                </button>
            </div>
        </>
    )
}
