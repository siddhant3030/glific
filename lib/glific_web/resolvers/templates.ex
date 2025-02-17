defmodule GlificWeb.Resolvers.Templates do
  @moduledoc """
  Templates Resolver which sits between the GraphQL schema and Glific Templates Context API. This layer basically stitches together
  one or more calls to resolve the incoming queries.
  """

  alias Glific.{Repo, Templates, Templates.SessionTemplate}

  @doc """
  Get a specific session template by id
  """
  @spec session_template(Absinthe.Resolution.t(), %{id: integer}, %{context: map()}) ::
          {:ok, any} | {:error, any}
  def session_template(_, %{id: id}, %{context: %{current_user: user}}) do
    with {:ok, session_template} <-
           Repo.fetch_by(SessionTemplate, %{id: id, organization_id: user.organization_id}),
         do: {:ok, %{session_template: session_template}}
  end

  @doc """
  Get the list of session templates filtered by args
  """
  @spec session_templates(Absinthe.Resolution.t(), map(), %{context: map()}) ::
          {:ok, any} | {:error, any}
  def session_templates(_, args, _) do
    {:ok, Templates.list_session_templates(args)}
  end

  @doc """
  Get the count of session templates filtered by args
  """
  @spec count_session_templates(Absinthe.Resolution.t(), map(), %{context: map()}) ::
          {:ok, integer}
  def count_session_templates(_, args, _) do
    {:ok, Templates.count_session_templates(args)}
  end

  @doc false
  @spec create_session_template(Absinthe.Resolution.t(), %{input: map()}, %{context: map()}) ::
          {:ok, any} | {:error, any}
  def create_session_template(_, %{input: params}, _) do
    with {:ok, session_template} <- Templates.create_session_template(params) do
      {:ok, %{session_template: session_template}}
    end
  end

  @doc false
  @spec update_session_template(Absinthe.Resolution.t(), %{id: integer, input: map()}, %{
          context: map()
        }) ::
          {:ok, any} | {:error, any}
  def update_session_template(_, %{id: id, input: params}, %{context: %{current_user: user}}) do
    with {:ok, session_template} <-
           Repo.fetch_by(SessionTemplate, %{id: id, organization_id: user.organization_id}),
         {:ok, session_template} <- Templates.update_session_template(session_template, params) do
      {:ok, %{session_template: session_template}}
    end
  end

  @doc false
  @spec delete_session_template(Absinthe.Resolution.t(), %{id: integer}, %{context: map()}) ::
          {:ok, any} | {:error, any}
  def delete_session_template(_, %{id: id}, %{context: %{current_user: user}}) do
    with {:ok, session_template} <-
           Repo.fetch_by(SessionTemplate, %{id: id, organization_id: user.organization_id}) do
      Templates.delete_session_template(session_template)
    end
  end

  @doc """
  Converting a message to message template
  """
  @spec create_template_from_message(
          Absinthe.Resolution.t(),
          %{message_id: integer, input: map()},
          %{context: map()}
        ) ::
          {:ok, any} | {:error, any}
  def create_template_from_message(_, params, _) do
    with {:ok, session_template} <- Templates.create_template_from_message(params) do
      {:ok, %{session_template: session_template}}
    end
  end

  @doc """
  Import pre approved templates
  """
  @spec import_templates(Absinthe.Resolution.t(), %{data: String.t()}, %{
          context: map()
        }) :: {:ok, any} | {:error, any}
  def import_templates(_, %{data: data}, %{context: %{current_user: user}}),
    do: Templates.import_templates(user.organization_id, data)

  @doc """
  Sync hsm with bsp
  """

  @spec sync_hsm_template(Absinthe.Resolution.t(), map(), %{context: map()}) ::
          {:ok, any} | {:error, any}
  def sync_hsm_template(_, _, %{context: %{current_user: user}}) do
    case Templates.sync_hsms_from_bsp(user.organization_id) do
      :ok -> {:ok, %{message: "successfull"}}
      {:error, error} -> {:error, error}
    end
  end
end
