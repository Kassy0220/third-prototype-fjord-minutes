import React from "react";
import Tooltip from "./Tooltip";

export default function AttendanceTable({ year, records }) {
    const [dates, attendances] = separateDataIntoDateAndAttendance(records)

    return (
        <div>
            <p>{year}年</p>
            <table className='attendance_table'>
                <thead>
                    <tr>
                        {dates.map(date => <th key={date.id}>{date.date}</th>)}
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        {attendances.map(attendance => <TableData key={attendance.id} attendance={attendance.attendance} absence_reason={attendance.absence_reason} />)}
                    </tr>
                </tbody>
            </table>
        </div>
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

function TableData({ attendance, absence_reason }) {
    if (attendance === 'absence') {
        return (
            <td>
                <Tooltip content={absence_reason}>
                    <span>休</span>
                </Tooltip>
            </td>
        )
    }

    const labels = { day: '昼', night: '夜', hiatus: '休止中' }

    return (
        <td>{attendance ? labels[attendance] : '---'}</td>
    )
}
