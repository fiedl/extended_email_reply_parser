module FixtureHelper
  def load_email(fixture_name)
    if File.exists? "spec/email_fixtures/#{fixture_name}.txt"
      IO.read("spec/email_fixtures/#{fixture_name}.txt").encode('utf-8')
    elsif File.exists? "spec/email_fixtures/#{fixture_name}.eml"
      IO.read("spec/email_fixtures/#{fixture_name}.eml").encode('utf-8')
    else
      raise "Fixture spec/email_fixtures/#{fixture_name} not found."
    end
  end
end