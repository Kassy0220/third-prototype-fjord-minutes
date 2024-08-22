class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github developer]

  has_many :attendances, dependent: :destroy
  has_many :minutes, through: :attendances
  has_many :hiatuses
  belongs_to :course

  scope :active, -> { where.not(id: hiatus.pluck(:id)) }
  scope :hiatus, -> { joins(:hiatuses).where(hiatuses: { finished_at: nil }) }

  def self.from_omniauth(auth, params)
    # TODO: ログイン時にユーザー情報を更新できる様にする
    # find_or_create_byだと、GitHubアカウントを更新してログインしても、更新が反映されない
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |member|
      member.email = auth.info.email
      member.name = auth.info.nickname
      member.avatar_url = auth.info.image
      member.password = Devise.friendly_token[0, 20]
      member.course_id = params['course_id'].to_i
    end
  end

  def login_name
    # GitHub認証を行っていないメンバーはnameを持たないため、メールアドレスの先頭を表示しておく(本番環境では削除)
    name ? name : email.slice(/^[^@]+/)
  end

  def hiatus?
    hiatuses.present? && hiatuses.exists?(finished_at: nil)
  end
end
