import React, { useState, useEffect } from "react";
import consumer from "../channels/consumer";

export default function ReleaseInformationForm({ minute_id, informationType, release_information }) {
    const [releaseInformation, setReleaseInformation] = useState(release_information)
    const [isEditing, setIsEditing] = useState(false);

    useEffect(() => {
        consumer.subscriptions.create({ channel: 'MinuteChannel', id: minute_id }, {
            received(data) {
                if (informationType === 'releaseBranch') {
                    setReleaseInformation(data.body.release_branch)
                } else {
                    setReleaseInformation(data.body.release_note)
                }

            }
        });
    }, [minute_id]);

    return (
        <>
            {isEditing ?
                <EditForm
                    informationType={informationType}
                    informationContent={releaseInformation}
                    setIsEditing={setIsEditing}
                    minuteId={minute_id}
                />
                :
                <ReleaseInformation
                    informationType={informationType}
                    informationContent={releaseInformation}
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
