class SessionsController < ApplicationController
  def create
    code = params["code"]

    token_data = exchange_code(code)
    puts("token_data")
    puts(token_data)

    user_info = user_info(token_data["access_token"])
    puts("user_info")
    puts(user_info)

    user = User.find_or_create_by!(username: user_info["login"])
    session = Session.create(user_id: user.id, access_token: token_data["access_token"])

    redirect_to home_index_path, notice: 'ログインしました'
  end

  private

  def exchange_code(code)
    params = {
      "client_id" => ENV["GITHUB_CLIENT_ID"],
      "client_secret" => ENV["GITHUB_CLIENT_SECRET"],
      "code" => code
    }

    response = Net::HTTP.post(
      URI("https://github.com/login/oauth/access_token"),
      URI.encode_www_form(params),
      {"Accept" => "application/json"}
    )

    parse_response(response)
  end

  def user_info(access_token)
    puts access_token
    uri = URI("https://api.github.com/user")
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      body = {"access_token" => access_token}.to_json
      auth = "Bearer #{access_token}"
      headers = {
        "Content-Type" => "application/json",
        "Accept" => "application/json",
        "Authorization" => auth
      }

      http.send_request("GET", uri.path, body, headers)
    end

    parse_response(response)
  end

  def parse_response(response)
    case response
    when Net::HTTPOK
      JSON.parse(response.body)
    else
      puts response
      puts response.body
      {}
    end
  end
end
