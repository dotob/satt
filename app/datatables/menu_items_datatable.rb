class MenuItemsDatatable < ApplicationController
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view, user_order)
    @view = view
    @user_order = user_order
    @menu = user_order.master_order.menu
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: MenuItem.all_menu_items_by_menu_id(@menu.id).count,
      iTotalDisplayRecords: menu_items.total_entries,
      aaData: data
    }
  end

private

  def data
    menu_items.map do |menu_item|
      [
        menu_item.order_number,
        menu_item.name,
        menu_item.description,
        number_to_currency(menu_item.price),
        form_for_menu_item_add(menu_item),
      ]
    end
  end

  def form_for_menu_item_add(menu_item)
    "<a class=\"btn btn-success\" href=\"/add_orderitem/#{@user_order.id}/#{menu_item.id}\"><i class=\"icon-plus icon-white\"></i></a>"    
  end

  def menu_items
    @menu_items ||= fetch_menu_items
  end

  def fetch_menu_items
    order_by_string = "#{sort_column} #{sort_direction}"
    menu_items = MenuItem.all_menu_items_by_menu_id(@menu.id).order(order_by_string)
    menu_items = menu_items.page(page).per_page(per_page)
    use4like = Rails.configuration.db_use4like 
    if params[:sSearch].present?
      menu_items = menu_items.where("name #{use4like} :search or description #{use4like} :search or order_number #{use4like} :search", search: "%#{params[:sSearch]}%")
    end
    menu_items
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 20
  end

  def sort_column
    columns = %w[order_number name description price]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end