import React from "react";
import useSWR from "swr";
import fetcher from "../fetcher";
import AttendanceTable from "./attendanceTable";

export default function TotalAttendances({ member_id }) {
    const { data, error, isLoading } = useSWR(`/api/members/${member_id}/attendances`, fetcher)

    if (error) return <p>エラーが発生しました</p>
    if (isLoading) return <p>読み込み中</p>

    const attendances = attendancesPerYear(data)

    return (
        <div>
            {/* keyには、各テーブルで一番目に表示される出席のIDを用いる(出席が増加しても一番目に表示されるデータは変わらないため) */}
            {attendances.map((attendance) => <AttendanceTable key={attendance.records[0][0]} year={attendance.year} records={attendance.records} />)}
        </div>
    )
}

function attendancesPerYear(data) {
    return data.reduce((recordsPerYear, d) => {
        const year = d[1].slice(0, 4)
        const record = recordsPerYear.find((record) => record.year === year)

        record ? record.records.push(d) : recordsPerYear.push({ year, records: [d] })

        return recordsPerYear
    }, [])
}
