defmodule Issues.GithubIssues do
  alias HTTPotion.Response

  @user_agent ["User-agent": "Elixir glen@atpay.com"]

  def fetch(user, project) do
    case issues_url(user, project) |> HTTPotion.get(@user_agent) do
      Response[body: body, status_code: status, headers: _headers] when status in 200..299 -> { :ok, body }
      Response[body: body, status_code: status, headers: _headers] -> { :error, body }
    end
  end

  def issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end
end