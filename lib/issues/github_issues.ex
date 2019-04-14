defmodule Issues.GithubIssues do
    
    @user_agent [{"User-agent", "Trialx shahid.yousuf@trialx.com"}]

    def fetch(user, project) do
        # we also need to pass user_agent to github api in addition to the url
        issues_url(user, project)
        |> HTTPoison.get(@user_agent)
        |> handle_response
    end

    def issues_url(user, project) do
        "https://api.github.com/repos/#{user}/#{project}/issues"
    end

    def handle_response({:ok, %{status_code: 200, body: body}}) do
        {:ok, body}
    end
    def handle_response({:ok, %{status_code: 404, body: body}}) do
        {:ok, body}
    end
    def handle_response({:error,%{reason: reason}}) do
        {:error, reason}
    end
end