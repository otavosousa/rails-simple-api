module Api::V1
  class ApiController < ApplicationController
    # verifica se o token enviado pela requisição bate com o token do usuario
    acts_as_token_authentication_handler_for User
  end
end
