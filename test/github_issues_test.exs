defmodule HTTPotion do
  defrecord Response, status_code: nil, body: nil, headers: []

  def get("https://api.github.com/repos/good/success/issues", _agent), do: Response[status_code: 200, body: "success"]
  def get("https://api.github.com/repos/bad/error/issues", _agent), do: Response[status_code: 404, body: "error"]
end

defmodule GithubIssuesTest do
  use ExUnit.Case
  import Issues.GithubIssues, only: [ fetch: 2, issues_url: 2 ]

  test "Returns ok when request was successful" do        
    assert fetch("good", "success") == { :ok, "success" }
  end

  test "Returns error when request fails" do
    assert fetch("bad", "error") == { :error, "error"}
  end
end