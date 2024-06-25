import React from "react";
import useSWR from "swr";
import fetcher from "../fetcher";

export default function Attendee({ minute_id}) {
    const { data, error, isLoading } = useSWR(`/api/minutes/${minute_id}`, fetcher)

    if (error) return <p>エラーが発生しました</p>
    if (isLoading) return <p>読み込み中</p>
    console.log(data)

    return (
        <ul>
            <li>
                プログラマー
                <ul>
                    <li>
                        昼
                        <Members
                            attendances={data.day}
                        />
                    </li>
                    <li>
                        夜
                        <Members
                            attendances={data.night}
                        />
                    </li>
                </ul>
            </li>
            <li>
                プロダクトオーナー
                <ul>
                    <li>
                        @machida
                    </li>
                </ul>
            </li>
            <li>
                プログラマー
                <ul>
                    <li>
                        @komagata
                    </li>
                </ul>
            </li>
        </ul>
    )
}

function Members({ attendances }) {
    if (attendances.length === 0) {
        return null
    }

    return (
        <ul>
            { attendances.map(attendance => <li key={attendance.attendance_id}>{attendance.member_name}</li>) }
        </ul>
    )
}
