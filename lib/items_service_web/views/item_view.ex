defmodule ItemsServiceWeb.ItemView do
  use ItemsServiceWeb, :view
  use JSONAPI.View, type: "items"

  alias ItemsServiceWeb.ItemView

  def fields do
    [:id, :parent_id, :name, :priority]
  end

  def relationships do
    [parent: ItemView, children: ItemView]
  end
end
