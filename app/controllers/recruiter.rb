class Recruiter
  attr_accessor :Name, :Email, :Zip

  def initialize(name, email, zip)
    self.Name = name
    self.Email = email
    self.Zip = zip
  end

  def to_json (options = {})
    {'Name' => self.Name, 'Email' => self.Email, 'Zip' => self.Zip}.to_json (options)
  end

  def self.from_json (string)
    data = JSON.parse(string)
    self.new(data['Name'], data['Email'], data['Zip'])
  end


  #def marshal_dump
    #[Name, Email, Zip]
  #end

  #def marshal_load array
    #Name, Email, Zip = array
  #end
end