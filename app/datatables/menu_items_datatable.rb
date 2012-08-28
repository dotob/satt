class MenuItemsDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view
  include ActionView::Helpers::FormTagHelper

  def initialize(view, menu_id)
    @view = view
    @menu_id = menu_id
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: MenuItem.all_menu_items_by_menu_id(@menu_id).count,
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
    return form_tag ('/add_orderitem')
    form_tag ('/add_orderitem') do
      hidden_field_tag "menu_item_id" , item.id
      hidden_field_tag "master_order_id", @master_order.id
      hidden_field_tag "user_order_id", @current_user_order.id
      button_tag('Dazu', :class => "btn btn-success", :disabled => @master_order.deadline_crossed) do 
        content_tag(:i, "", :class => "icon-plus icon-white")
      end 
    end
  end

  def menu_items
    @menu_items ||= fetch_menu_items
  end

  def fetch_menu_items
    menu_items = MenuItem.all_menu_items_by_menu_id(@menu_id).order("#{sort_column} #{sort_direction}")
    menu_items = menu_items.page(page).per_page(per_page)
    if params[:sSearch].present?
      menu_items = menu_items.where("name like :search or description like :search or order_number like :search", search: "%#{params[:sSearch]}%")
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
    columns = %w[order_number name description price]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end