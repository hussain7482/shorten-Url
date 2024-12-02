class Url < ApplicationRecord
  validates :original_url, presence: true, format: URI::DEFAULT_PARSER.make_regexp
  before_create :generate_short_code

  private

  def generate_short_code
    self.short_code = SecureRandom.hex(4) # Generates an 8-character hex code
  end
end
