class Api::V1::ContactsController < Api::V1::ApiController
  def index
    render json: {
      data: Contact.all
    }
  end
end
