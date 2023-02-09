defmodule NameBadge do
  def print(id, name, department) do
    id = if id do
      "[#{id}] - "
    else
      ""
    end
    department = if department do
      " - #{String.upcase(department)}"
    else
      " - OWNER"
    end
    id <> name <> department
  end
end
