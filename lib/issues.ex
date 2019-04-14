defmodule Issues do
  @moduledoc """
  Documentation for Issues.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Issues.hello()
      :world

  """
  @author "Shahid Yousuf"
  @profession "Software Developer"
  @email "shahid.yousuf@trialx.com"
  @company "TrialX | Applied Informatics Pvt. Ltd."

  def info do
    "App: issues, created by #{@author}, #{@profession} at #{@company}. Email at #{@email} "
  end
end
