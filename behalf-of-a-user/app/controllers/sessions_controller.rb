class SessionsController < ApplicationController
  def create
    code = params["code"]

    redirect_to home_index_path, notice: 'ログインしました'
  end
end
