class GithubWikiManager
  include MinutesHelper
  include DateHelper
  BOOTCAMP_WORKING_DIRECTORY = Rails.root.join('bootcamp_wiki_repository').freeze
  AGENT_WORKING_DIRECTORY = Rails.root.join('agent_wiki_repository').freeze

  def self.export_minute(minute)
    new(minute.course).export_minute(minute)
  end

  def initialize(course)
    @working_directory = course.name == 'Railsエンジニアコース' ? BOOTCAMP_WORKING_DIRECTORY : AGENT_WORKING_DIRECTORY
    wiki_url = course.name == 'Railsエンジニアコース' ? ENV['BOOTCAMP_WIKI_URL'] : ENV['AGENT_WIKI_URL']
    @git = Dir.exist?(@working_directory) ? Git.open(@working_directory, log: Logger.new(STDOUT))
                                          : Git.clone(wiki_url, @working_directory)
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

  def export_minute(minute)
    # TODO: 例外が発生した時の処理を書く
    @git.pull
    commit_minute(minute)
    @git.push('origin', 'master')
  end

  def commit_minute(minute)
    filepath = "#{@working_directory}/#{minute.title}.md"
    minute_markdown = MinuteTemplate.build(minute, attendees_list(minute.day_attendees), attendees_list(minute.night_attendees), topics_list(minute.topics), format_date(minute.next_date), absentees_list(minute.absentees))

    File.open(filepath, 'w+') do |file|
      file.write minute_markdown
    end

    @git.add("#{minute.title}.md")
    @git.commit("#{minute.title}.mdを作成")
  end
end
