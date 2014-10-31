require 'rubygems'
require 'active_record'

# following is the database settings

ActiveRecord::Base.establish_connection(
    :adapter=> "mysql",
    :host => "localhost",
    :database => "fileconsole",
    :username => "root",
    :password => "netserv"
)

# classes based on the database, as always
class Rsoft < ActiveRecord::Base
end