defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions that end up generating a table of the last _n_ issues in a github project
  """

  def run(argv) do
    argv |> parse_args |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.
  
  Otherwise it is a github username, project name, and (optionally) the number of entries to format.

  Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])

    case parse do
      { [help: true], _, _ } -> :help
      { _, [user, project, count], _ } -> { user, project, binary_to_integer(count) }
      { _, [user, project], _ } -> { user, project, @default_count }
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [ count | #{@default_count} ]
    """

    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> convert_to_list_of_hashdicts
    |> sort_into_ascending_order
    |> Enum.take(count)
  end

  def decode_response({ :ok, body }), do: Jsonex.decode(body)
  def decode_response({ :error, msg }) do
    error = Jsonex.decode(msg)["message"]
    IO.puts "Error fetching from Github: #{error}"

    System.halt(2)
  end

  def convert_to_list_of_hashdicts(list), do: list |> Enum.map(&HashDict.new/1)

  def sort_into_ascending_order(issue_list), do: Enum.sort(issue_list, &(&1["created_at"] <= &2["created_at"]))
end