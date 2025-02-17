defmodule Glific.Repo.Migrations.AddGroupsPermissions do
  use Ecto.Migration

  def change do
    create_group_roles()
    create_trigger_roles()
  end

  defp create_group_roles() do
    create table(:group_roles) do
      add :role_id, references(:roles, on_delete: :delete_all), null: false
      add :group_id, references(:groups, on_delete: :delete_all), null: false
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false
    end

    create index(:group_roles, :organization_id)
    create unique_index(:group_roles, [:role_id, :group_id, :organization_id])
  end

  defp create_trigger_roles() do
    create table(:trigger_roles) do
      add :role_id, references(:roles, on_delete: :delete_all), null: false
      add :trigger_id, references(:triggers, on_delete: :delete_all), null: false
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false
    end

    create index(:trigger_roles, :organization_id)
    create unique_index(:trigger_roles, [:role_id, :trigger_id, :organization_id])
  end
end
