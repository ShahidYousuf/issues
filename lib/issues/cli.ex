defmodule Issues.CLI do
    
    @default_count 4

    @moduledoc """
    Handle the command line parsing and the dispatch to
    various functions that end up generating a table of
    the last __n__ issues of a github project.
    """

    def main(argv) do
        argv
            |> parse_args
            |> process
    end

    def parse_args(argv) do
        parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h:  :help])

        case parse do
            {[ help: true ], _, _} -> :help
            {_, [user, project, count], _} -> { user, project, String.to_integer(count)}
            {_, [user, project], _} -> { user, project, @default_count}
            _ -> :help
        end
    end

    def process(:help) do
        IO.puts """
            usage : issues <user> <project> [ count | #{@default_count}]
            """
        System.halt(0)
    end

    def process({user, project, count}) do
        Issues.GithubIssues.fetch(user, project)
        |> decode_response
        |> convert_to_list_of_hashdicts
        |> sort_into_ascending_order
        |> Enum.take(count)
        |> print_data
    end

    def decode_response({:ok, body}) do
        body    
    end
    def decode_response({:error, reason}) do
        List.insert_at([], 0, reason)
    end

    def convert_to_list_of_hashdicts(list) when is_list(hd(list)) do
        list
           |> Enum.map(&Enum.into(&1, HashDict.new))
    end

    def convert_to_list_of_hashdicts(list) do
        list
    end

    def sort_into_ascending_order(list_of_issues) when is_map(hd(list_of_issues)) do
        Enum.sort(list_of_issues, fn a, b -> a["created_at"] <= b["created_at"] end)
    end

    def sort_into_ascending_order(list_of_issues) do
        list_of_issues
    end

    def print_data(list) when is_map(hd(list)) do
        Enum.map(list, fn rec -> to_string(rec["number"]) <> " " <> to_string(rec["created_at"]) <> " " <> to_string(rec["title"]) end)
    end

    def print_data(list) do
        list
    end
   
end