require 'pry'
class Dog 
  attr_accessor :name, :breed, :id
  
  
  def initialize(attributes)
    attributes.each do |key,value|
      instance_variable_set("@#{key}",value) 
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
    new_dog = self.new 
    new_dog.id = row[0]
    new_dog.name =  row[1]
    new_dog.grade = row[2]
    new_dog  
  end
end