class Api::V1::ApplicationController < ActionController::API

  def generate_pagination(paginated_obj)
    # current page, previous page, next page, total pages
    {
      pagination: {
        previous_page: paginated_obj.prev_page,
        current_page: paginated_obj.current_page,
        next_page: paginated_obj.next_page,
        total_pages: paginated_obj.total_pages
      }
    }
  end
end
