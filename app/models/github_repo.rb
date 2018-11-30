class GithubRepo

  attr_reader :name, :url

  def initialize(hash)
    @name = hash["name"]
    @url = hash["html_url"]
  end

  def authenticate!(client_secret, client_id, code)
    response = Faraday.post "https://github.com/login/oauth/access_token" do |resp|
        resp.body = {'client_id': ENV['GITHUB_CLIENT_ID'], 'client_secret': ENV['GITHUB_CLIENT_SECRET'], 'code': params['code'] }
        resp.headers['Accept'] = 'application/json'
    end
      body = JSON.parse(response.body)
      session[:token] = body['access_token']

  end

  def create(name)
    response = Faraday.post "https://api.github.com/user/repos", {name: params[:name]}.to_json, {'Authorization' => "token #{session[:token]}", 'Accept' => 'application/json'}
    redirect_to '/'
  end

end
