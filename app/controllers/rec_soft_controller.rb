require_relative "dbmock"
require "uri"
require "cgi"

class RecSoftController < ApplicationController

  $storage_arg = "MYSQL"

  def home
    @dbmock_instance = Dbmock.new
    $hash_recruiters = @dbmock_instance.mysql_get()
  end

  def dropsoft
    @dbmock_instance = Dbmock.new
    if (@dbmock_instance.delete_recruiter(params[:recruiter_id]) == true)
      @drop_status = "Successfully deleted."
    else
      @drop_status = "Invalid recruiter ID."
    end
  end
end
