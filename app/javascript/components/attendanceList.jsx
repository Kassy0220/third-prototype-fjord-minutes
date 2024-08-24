import React from "react";
import useSWR from "swr";
import fetcher from "../fetcher";

export default function AttendanceList({ member_id }) {
    const { data, error, isLoading } = useSWR(`/api/members/${member_id}/attendances`, fetcher)

    if (error) return <p>エラーが発生しました</p>
    if (isLoading) return <p>読み込み中</p>

    const [dates, attendances] = separateDataIntoDateAndAttendance(data)

    return (
        <table className='attendance_table'>
            <thead>
                <tr>
                    {dates.map(date => <th key={date.id}>{date.date}</th>)}
                </tr>
            </thead>
            <tbody>
                <tr>
                    {attendances.map(attendance => <td key={attendance.id}>{attendance.attendance}</td>)}
                </tr>
            </tbody>
        </table>
    )
}

function separateDataIntoDateAndAttendance(data) {
    const dates = []
    const attendances = []

    data.forEach((d) => {
        dates.push({ id: d[0], date: formatDate(d[1]) })
        attendances.push({ id: d[0], attendance: d[2], absence_reason: d[3] })
    })

    return [dates, attendances]
}

function formatDate(date) {
    const matched_date = date.match(/\d{4}-(\d{2})-(\d{2})/)
    return `${matched_date[1]}/${matched_date[2]}`
}