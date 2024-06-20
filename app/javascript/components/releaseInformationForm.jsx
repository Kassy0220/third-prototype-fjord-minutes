import React, { useState } from "react";
import useSWR, { mutate } from "swr";
import fetcher from "../fetcher";

export default function ReleaseInformationForm({ minute_id, informationType }) {
    const { data, error, isLoading } = useSWR(`/api/minutes/${minute_id}`, fetcher);
    const [isEditing, setIsEditing] = useState(false);

    if (error) return <div>エラーが発生しました！</div>;
    if (isLoading) return <div>読み込み中です...</div>;

    const informationContent = informationType === 'releaseBranch' ? data.release_branch : data.release_note;
    return (
        <>
            {isEditing ?
                <EditForm
                    informationType={informationType}
                    informationContent={informationContent}
                    setIsEditing={setIsEditing}
                    minuteId={minute_id}
                />
                :
                <ReleaseInformation
                    informationType={informationType}
                    informationContent={informationContent}
                    setIsEditing={setIsEditing}
                />
            }
        </>
    )
}

const EditForm = ({ informationType, informationContent, setIsEditing, minuteId }) => {
    const [inputValue, setInputValue] = useState(informationContent)
    const isReleaseBranch = informationType === 'releaseBranch'
    const handleInput = (e) => {
        setInputValue(e.target.value);
    }

    const handleClick = async function(e) {
        e.preventDefault();
        let information = {};
        if (isReleaseBranch) {
            information.release_branch = inputValue;
        } else {
            information.release_note = inputValue;
        }

        const parameter = { minute: information };
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
            <p>{isReleaseBranch ? 'リリースブランチ' : 'リリースノート'}</p>
            <div>
                <input
                    type="text"
                    id={isReleaseBranch ? 'release_branch' : 'release_note'}
                    value={inputValue}
                    onChange={handleInput}
                />
                <button onClick={handleClick}>更新</button>
            </div>
        </>
    )
}

const ReleaseInformation = ({ informationType, informationContent, setIsEditing }) => {
    const informationLabel = informationType === 'releaseBranch' ? 'リリースブランチ' : 'リリースノート'
    const content = informationContent ? informationContent : '未登録';

    return (
        <>
            <p>{informationLabel}</p>
            <div>
                <span>{content}</span>
                <button onClick={() => {
                    setIsEditing(true)
                }}>
                    編集
                </button>
            </div>
        </>
    )
}
