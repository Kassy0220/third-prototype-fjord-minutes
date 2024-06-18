import React, { useState } from "react";
import useSWR, { mutate } from "swr";
import fetcher from "../fetcher";

export default function ReleaseBranchForm({ minute_id }) {
    const { data, error, isLoading } = useSWR(`/api/minutes/${minute_id}`, fetcher);
    const [isEditing, setIsEditing] = useState(false);

    if (error) return <div>エラーが発生しました！</div>;
    if (isLoading) return <div>読み込み中です...</div>;

    const releaseBranch = data.release_branch;
    return (
        <>
            {isEditing ?
                <EditForm
                    releaseBranch={releaseBranch}
                    setIsEditing={setIsEditing}
                    minuteId={minute_id}
                />
                :
                <ReleaseBranch
                    releaseBranch={releaseBranch}
                    setIsEditing={setIsEditing}
                />
            }
        </>
    )
}

const EditForm = ({ releaseBranch, setIsEditing, minuteId }) => {
    const [inputValue, setInputValue] = useState(releaseBranch)
    const handleInput = (e) => {
        setInputValue(e.target.value);
    }

    const handleClick = async function(e) {
        e.preventDefault();
        const parameter = { minute: { release_branch: inputValue } };
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
        <>
            <p>リリースブランチ</p>
            <div>
                <input
                    type="text"
                    id="release_branch"
                    value={inputValue}
                    onChange={handleInput}
                />
                <button onClick={handleClick}>更新</button>
            </div>
        </>
    )
}

const ReleaseBranch = ({ releaseBranch, setIsEditing }) => {
    const branchInfo = releaseBranch ? releaseBranch : '未登録';
    return (
        <>
            <p>リリースブランチ</p>
            <div>
                <span>{branchInfo}</span>
                <button onClick={() => {
                    setIsEditing(true)
                }}>
                    編集
                </button>
            </div>
        </>
    )
}
