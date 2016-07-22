module FixtureHelper
  def load_email(fixture_name)
    IO.read("spec/email_fixtures/#{fixture_name}.txt").encode('utf-8')
  end
end