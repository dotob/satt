class MenuItemsDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: MenuItem.count,
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
        "addme",
        "addme",
      ]
    end
  end

  def menu_items
    @menu_items ||= fetch_menu_items
  end

  def fetch_menu_items
    menu_items = MenuItem.order("#{sort_column} #{sort_direction}")
    menu_items = menu_items.page(page).per_page(per_page)
    if params[:sSearch].present?
      menu_items = menu_items.where("name like :search or category like :search", search: "%#{params[:sSearch]}%")
    end
    menu_items
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[name category released_on price]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end