# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Minute.create(title: 'ふりかえり・計画ミーティング2024年06月26日')

minute = Minute.last

members_name = ['Kassy0220', 'sochi419', 'rira100000', 'unikounio', 'dowdiness', 'omochiumaiumai', 'Judee']

members_name.each do |member|
  Member.create!(email: "#{member}@example.com", password: 'testtest')
end

members = Member.all

day_attendees = members[0..2]
day_attendees.each do |day_attendee|
  minute.attendances.create!(time: :day, member: day_attendee)
end

night_attendees = members[3..4]
night_attendees.each do |night_attendee|
  minute.attendances.create!(time: :night, member: night_attendee)
end

minute.attendances.create!(time: :absence, absence_reason: '体調不良のため', progress_report: '今週はPR#1000に取り組んでいました。来週までにはレビュー依頼できそうです', member: members[5])

minute.attendances.create!(time: :absence, absence_reason: '仕事の都合のため', progress_report: '今週はレビュー返信のみ行いました。来週は依頼されたPR#1002を進めていきます', member: members[6])

minute.topics.create!(content: 'ローカルでテストが通らなくなった問題を共有したいです')
minute.topics.create!(content: '本番環境で動作確認を手伝ってくれるかたを募集しています')
