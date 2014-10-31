require_relative "recruiter"
require_relative "dbsql"
require "yaml"
require "json"

class Dbmock

  YAML_FILE = "database/yaml_database.yml"
  JSON_FILE = "database/json_database.json"
  MARSHAL_FILE = "database/marshal_database"

  $hash_recruiters = {}

  def add_recruiter(recruiter_instance)
    if $storage_arg == "MYSQL"
      Rsoft.create(:name => recruiter_instance.Name, :email => recruiter_instance.Email, :zip => recruiter_instance.Zip)
      mysql_get()
      return true
    else
      recruiter_id = 0
      $hash_recruiters.each { |k,v|
        if k > recruiter_id
          recruiter_id = k
        end
      }
      $hash_recruiters[recruiter_id + 1] = recruiter_instance

      return true
    end
  end

  def view_recruiter(recruiter_id)
    if $storage_arg == "MYSQL"
      mysql_get()
    end

    return $hash_recruiters[recruiter_id]
  end

  def update_recruiter(recruiter_id,recruiter_instance)
    if $storage_arg == "MYSQL"

      if Rsoft.exists?(recruiter_id)
        Rsoft.update(recruiter_id, :name => recruiter_instance.Name, :email => recruiter_instance.Email, :zip => recruiter_instance.Zip)
        mysql_get()
        return true
      else
        return false
      end

    else
      $hash_recruiters[recruiter_id] = recruiter_instance
      return true
    end
  end

  def delete_recruiter(recruiter_id)
    if $storage_arg == "MYSQL"
      if Rsoft.exists?(recruiter_id)
        Rsoft.find(recruiter_id).destroy
        mysql_get()
        return true
      else
        return false
      end
    else
      recruiter_instance = $hash_recruiters.delete(recruiter_id)
      if recruiter_instance == nil
        return false
      else
        return true
      end
    end
  end

  def yaml_put(hash_instance)
    File.open(YAML_FILE, "w") {|f| f.write(hash_instance.to_yaml) }
    return true
  end

  def yaml_get()
    parsed = begin
      $hash_recruiters = YAML.load(File.open(YAML_FILE))
    rescue ArgumentError => e
      puts "Could not parse YAML: #{e.message}"
    end
    return $hash_recruiters
  end

  def json_put(hash_instance)
    File.open(JSON_FILE, "w") {|f| f.write(JSON.pretty_generate(hash_instance)) }
    return true
  end

  def json_get()

    parsed = begin
      $hash_recruiters.clear
      hash_json = JSON.load(File.read(JSON_FILE))
      hash_json.each { |k,v| $hash_recruiters[k.to_i] = Recruiter.new(v['Name'],v['Email'],v['Zip']) }
    rescue ArgumentError => e
      puts "Could not parse JSON: #{e.message}"
    end

    return $hash_recruiters
  end

  def marshal_put(hash_instance)
    File.open(MARSHAL_FILE, "w") {|f| f.write(Marshal.dump($hash_recruiters)) }
    return true
  end

  def marshal_get()

    parsed = begin
      $hash_recruiters.clear
      marshal_file = File.open(MARSHAL_FILE)
      $hash_recruiters = Marshal.load(marshal_file)
    rescue ArgumentError => e
      puts "Could not parse JSON: #{e.message}"
    end

    return $hash_recruiters
  end

  def mysql_put(hash_instance)
    return true
  end

  def mysql_get()

    parsed = begin
      $hash_recruiters.clear

      rsoftdata_instance = Rsoft.all
      rsoftdata_instance.each  {
        |data|
        $hash_recruiters[data.id.to_i] = Recruiter.new(data.name,data.email,data.zip)
        #puts "mydata #{data.id},#{data.name}"
      }

    rescue ArgumentError => e
      puts "Could not load from mysql: #{e.message}"
    end

    return $hash_recruiters
  end

end