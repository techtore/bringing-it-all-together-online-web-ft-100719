require 'pry'
class Dog 
  attr_accessor :name, :breed
  attr_reader :id
  
  
  def initialize(attributes)
    attributes.each do |key,value|
      instance_variable_set("@#{key}",value) unless value.nil?
      @id ||= nil
    end
  end
  
  def self.create_table 
    sql = <<-SQL 
      CREATE TABLE IF NOT EXISTS dogs(
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT);
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql= <<-SQL 
    DROP TABLE IF EXISTS dogs;
    SQL
    DB[:conn].execute(sql)
  end
  
  def save 
      sql= <<-SQL 
        INSERT INTO dogs (name, breed)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.breed)
      @id =  DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      self
  end
  
  def self.create(attributes)
    dog = Dog.new(attributes) 
    dog.save
    dog 
  end
  
  def self.new_from_db(row)
    attributes_hash = {
      :id => row[0],
      :name => row[1],
      :breed => row[2]
    }
    self.new(attributes_hash) 
  end
  
  def self.find_by_id
    sql = <<-SQL 
      SELECT * FROM dogs 
      WHERE id = ?
    SQL
    DB[:conn].execute(sql, id).map do |row|
      self.new_from_db(row)
      
      
  end
end