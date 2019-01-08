require "nagbot/version"

require 'chronic_duration'
require 'yaml'

module Nagbot
  class Error < StandardError; end
  
  def self.scan(source_dir)
    Dir.glob(File.join(source_dir, '**', '*.md.erb')).map do |filename|
      filename.gsub("#{source_dir}/", '')
    end
  end

  def self.parse(content)
    frontmatter = content.split('---', 3)[1]
    YAML.load(frontmatter)
  end

  def self.nag?(data)
    if data['nag_after'].nil? || data['last_reviewed_on'].nil?
      false
    else
      diff = DateTime.now - data['last_reviewed_on']
      seconds = diff.to_i * 24 * 60 * 60
      seconds > ChronicDuration.parse(data['nag_after'])
    end
  end
end
