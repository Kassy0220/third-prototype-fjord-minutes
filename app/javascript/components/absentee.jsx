import React from 'react'
import useSWR from "swr";
import fetcher from "../fetcher";

export default function Absentee({ minute_id }) {
    const { data, error, isLoading } = useSWR(`/api/minutes/${minute_id}`, fetcher)

    if (error) return <p>エラーが発生しました</p>
    if (isLoading) return <p>読み込み中</p>

    console.log(Array.isArray(data.absence))
    if (data.absence.length === 0) {
        return null
    }

    return (
        <>
            { data.absence.map(absence => <Detail key={absence.attendance_id} member_name={absence.member_name} absence_reason={absence.absence_reason} progress_report={absence.progress_report} />) }
        </>
    )
}

function Detail({ member_name, absence_reason, progress_report }) {
    return (
        <div>
            <p className="absent_member_name">{member_name}</p>
            <div className="absent_report">
                <p>欠席理由 : {absence_reason}</p>
                <p>今週の進捗 : {progress_report}</p>
            </div>
        </div>
    )
}
