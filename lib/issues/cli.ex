defmodule Issues.CLI do
    
    @default_count 4

    @moduledoc """
    Handle the command line parsing and the dispatch to
    various functions that end up generating a table of
    the last __n__ issues of a github project.
    """

    def run(argv) do
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

    def process({user, project, _count}) do
        Issues.GithubIssues.fetch(user, project)
        |> decode_response
    end

    def decode_response({:ok, body}) do
        body
    end
    def decode_response({:error, reason}) do
        reason
    end
   
end