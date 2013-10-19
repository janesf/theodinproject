class Lesson < ActiveRecord::Base
  attr_accessible :course_id, :description, :is_project, :position, :section_id, :title, :url, :title_url

  belongs_to :section
  has_one :course, :through => :section

  def content
    github = Github::Repos.new :user => "theodinproject", :repo => "curriculum", :oauth_token => "#{ENV['GITHUB_API_TOKEN']}"
    begin
      response = github.contents.get :path => self.url
      # Decode the gibberish into a real file and render to html
      decoded_file = Base64.decode64(response["content"])
    # serve all errors as 404: Not Found
    # NOTE: API rate limit errors will still look like 404's now
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
    decoded_file
  end

end