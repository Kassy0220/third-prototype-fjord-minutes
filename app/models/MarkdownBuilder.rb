class MarkdownBuilder
  def initialize(minute)
    @minute = minute
    @markdown = ''
  end

  def build
    add_retrospective_chapter
    add_next_meeting_chapter
    add_planning_chapter
    add_absent_member_chapter

    @markdown
  end

  private
  def add_retrospective_chapter
    retrospective_chapter = "# ふりかえり\n\n"
    retrospective_chapter << member_section
    retrospective_chapter << demo_section
    retrospective_chapter << release_section
    retrospective_chapter << topic_section
    retrospective_chapter << others_section

    add_to_markdown(retrospective_chapter)
  end

  def member_section
    day_attendees = @minute.attendances.where(time: :day).includes(:member).pluck(:email)
                           .map{ |email| "- [#{email.slice(/^[^@]+/)}](#)" }.join("\n    ")
    night_attendees = @minute.attendances.where(time: :night).includes(:member).pluck(:email)
                             .map{ |email| "- [#{email.slice(/^[^@]+/)}](#)" }.join("\n    ")

    <<~MEMBER
      ## メンバー
      
      - プログラマー
        - 昼
          #{day_attendees}
        - 夜
          #{night_attendees}
      - プロダクトオーナー
        - [@machida](https://github.com/machida)
      - スクラムマスター
        - [@komagata](https://github.com/komagata)

    MEMBER
  end

  def demo_section
    <<~DEMO
      ## デモ
      今回のイテレーションで実装した機能をプロダクトオーナーに向けてデモします。（画面共有使用） 「お客様」相手にデモをするという設定なので、MTG前に事前に準備をしておくといいかもしれません。 テストデータなどは事前に準備しておいてください。

    DEMO
  end

  def release_section
    <<~RELEASE
      ## 今週のリリースの確認
      木曜日の15時頃リリースします

      - リリースブランチ
        - #{@minute.release_branch}
      - リリースノート
        - #{@minute.release_note}

    RELEASE
  end

  def topic_section
    topics = @minute.topics.map{ |topic| "- #{topic.content}" }.join("\n")
    <<~TOPIC
      ## 話題にしたいこと・心配事
      明確に共有すべき事・困っている事以外にも、気分的に心配な事などを話すためにあります。

      #{topics}

    TOPIC
  end

  def others_section
    <<~OTHERS
      ## その他
      
      #{@minute.other}

    OTHERS
  end

  def add_next_meeting_chapter
    add_to_markdown(<<~NEXT_MEETING)
      # 次回のMTG

      - #{@minute.next_date.strftime('%Y年%m月%d日')} (水)
        - 昼の部：15:00-16:00
        - 夜の部：22:00-23:00

    NEXT_MEETING
  end

  def add_planning_chapter
    add_to_markdown(<<~PLANNING)
      # 計画ミーティング

      - プランニングポーカー
    
    PLANNING
  end

  def add_absent_member_chapter
    absent_member = @minute.attendances.where(time: :absence).includes(:member).pluck(:email, :absence_reason, :progress_report)
                           .map{ |absence| "- [#{absence[0].slice(/^[^@]+/)}](#)\n  - 欠席理由: #{absence[1]}\n  - 進捗報告: #{absence[2]}" }.join("\n")
    add_to_markdown(<<~ABSENT_MEMBERS)
      # 欠席者

      #{absent_member}

    ABSENT_MEMBERS
  end

  def add_to_markdown(text)
    @markdown << text
  end
end