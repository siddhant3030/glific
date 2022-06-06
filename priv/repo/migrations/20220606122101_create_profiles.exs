defmodule Glific.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  @global_schema Application.fetch_env!(:glific, :global_schema)

  def change do
    create table(:profiles) do
      add :name, :string
      add :profile_type, :string
      add :profile_registration_fields, :map
      add :contact_profile_fields, :map
      add(:contact_id, references(:contacts, on_delete: :delete_all), null: false)
      add(:language_id, references(:languages, on_delete: :delete_all, prefix: @global_schema), null: false)

      timestamps(type: :utc_datetime)
    end
  end
end
