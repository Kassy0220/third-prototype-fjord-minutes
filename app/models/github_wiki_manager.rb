class GithubWikiManager
  include MinutesHelper
  include DateHelper
  BOOTCAMP_WORKING_DIRECTORY = Rails.root.join('bootcamp_wiki_repository').freeze

  def self.export_minute(minute, day_attendees, night_attendees, absent_members)
    new.export_minute(minute, day_attendees, night_attendees, absent_members)
  end

  def initialize
    @git = Dir.exist?(BOOTCAMP_WORKING_DIRECTORY) ? Git.open(BOOTCAMP_WORKING_DIRECTORY, log: Logger.new(STDOUT))
                                                  : Git.clone(ENV['BOOTCAMP_WIKI_URL'], BOOTCAMP_WORKING_DIRECTORY)
    set_github_account
    create_credential_file
  end

  def set_github_account
    @git.config('user.name', ENV['GITHUB_USER_NAME'])
    @git.config('user.email', ENV['GITHUB_USER_EMAIL'])
  end

  def create_credential_file
    credential_file_path = Rails.root.join('.netrc')
    return if File.exist?(credential_file_path)

    content = <<-CREDENTIAL
machine github.com
login #{ENV['GITHUB_USER_NAME']}
password #{ENV['GITHUB_ACCESS_TOKEN']}
    CREDENTIAL

    File.open(credential_file_path, 'w+') do |file|
      file.puts content
    end
    File.chmod(0600, credential_file_path)
  end

  def export_minute(minute, day_attendees, night_attendees, absent_members)
    # TODO: 例外が発生した時の処理を書く
    @git.pull
    commit_minute(minute, day_attendees, night_attendees, absent_members)
    @git.push('origin', 'master')
  end

  def commit_minute(minute, day_attendees, night_attendees, absent_members)
    filepath = "#{BOOTCAMP_WORKING_DIRECTORY}/#{minute.title}.md"
    minute_markdown = MinuteTemplate.build(minute, attendees_list(day_attendees), attendees_list(night_attendees), topics_list(minute.topics), format_date(minute.next_date), absentees_list(absent_members))

    File.open(filepath, 'w+') do |file|
      file.write minute_markdown
    end

    @git.add("#{minute.title}.md")
    @git.commit("#{minute.title}.mdを作成")
  end
end
