defmodule HTTPotion do
  defrecord Response, body: "", status_code: 0, headers: ""

  def get("https://api.github.com/repos/good/success/issues", _agent), do: Response.new(body: "success", status_code: 200)
  def get("https://api.github.com/repos/bad/error/issues", _agent), do: Response.new(body: "error", status_code: 404) 
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