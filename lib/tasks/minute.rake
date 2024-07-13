namespace :minute do
  desc 'Create minute and notify meeting members'
  task prepare_for_meeting: :environment do
    MeetingSecretary.prepare_for_meeting
  end
end
