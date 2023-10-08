class HomeController < ApplicationController
  def index
    @github_login_path = github_login_path
  end

  def github_login_path
    params = {
        "client_id" => ENV["GITHUB_CLIENT_ID"]
    }
    uri = URI("https://github.com/login/oauth/authorize")
    uri.query = params.to_query

    uri.to_s
  end
end
