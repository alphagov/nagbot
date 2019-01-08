require 'date'
require 'chronic_duration'

RSpec.describe Nagbot do
  it "has a version number" do
    expect(Nagbot::VERSION).not_to be nil
  end

  it "scans the source directory for .md.erb files" do
    expected_files = [
      'future.md.erb',
      'past1.md.erb',
      'past2.md.erb',
      'more/things.md.erb',
    ]

    expect(Nagbot.scan(File.join('spec', 'source'))).to match_array(expected_files)
  end

  it "parses the frontmatter of a .md.erb file" do
    test_content = <<~EOS
    ---
    title: Test
    last_reviewed_on: 2019-01-01
    nag_after: 2 days
    ---

    # Test
    EOS

    expected_frontmatter = {
      'title' => 'Test',
      'last_reviewed_on' => Date.parse('2019-01-01'),
      'nag_after' => '2 days',
    }

    expect(Nagbot.parse(test_content)).to eql(expected_frontmatter)
  end

  context "#nag?" do
    it "nags if the file is stale" do
      frontmatter = {
        'title' => 'Test',
        'last_reviewed_on' => Date.parse('2019-01-01'),
        'nag_after' => '2 days',
      }

      expect(Nagbot.nag?(frontmatter)).to eql(true)
    end

    it "doesn't nag if there is no nag_after" do
      frontmatter = {
        'title' => 'Test',
        'last_reviewed_on' => Date.parse('2019-01-01'),
      }

      expect(Nagbot.nag?(frontmatter)).to eql(false)
    end

    it "doesn't nag if there is no last_reviewed_on" do
      frontmatter = {
        'title' => 'Test',
      }

      expect(Nagbot.nag?(frontmatter)).to eql(false)
    end
  end
end
