require 'net/http'
require 'json'

class JsonPlaceholderAPI
  # Fetches a random todo item from the JSONPlaceholder API.
  #
  # @return [String] the JSON string representing a random todo item
  def self.get_random_todo_json
    uri      = URI("https://jsonplaceholder.typicode.com/todos/#{rand(1..100)}")
    response = Net::HTTP.get(uri)
  end
end

class Todo
  # Initializes a new Todo object.
  #
  # @param userId [Integer] the ID of the user who owns the todo
  # @param id [Integer] the ID of the todo
  # @param title [String] the title of the todo
  # @param completed [Boolean] whether the todo is completed
  def initialize(userId:, id:, title:, completed:)
    @id = id
    @userId = userId
    @title = title
    @completed = completed
  end

  # Creates a new Todo object from a JSON string.
  #
  # @param json [String] the JSON string representing a todo
  # @return [Todo] the new Todo object
  def self.from(json)
    raise 'Implement'
  end

  # Gets the value of an instance variable.
  #
  # @param var_name [String, Symbol] the name of the instance variable
  # @return [Object] the value of the instance variable
  def get(var_name)
    instance_variable_get(var_name)
  end
end


# The Store class is used to store objects in memory and save them to files as CSV.
class Store
  # Initializes a new Store object.
  def initialize
    @memory = []
    @files  = {}
  end

  # Adds an object to the store's memory.
  #
  # @param object [Object] the object to add to memory
  def add(object)
    @memory << object
  end

  # Returns the objects stored in memory.
  #
  # @return [Array<Object>] the objects stored in memory
  def memory
    @memory
  end

  # Saves the objects in memory to files as CSV.
  def save
    @memory.each do |object|
      line = []
      object.instance_variables.each do |iv|
        line << object.get(iv)
      end
      file_for(object).puts line.join(',')
    end
  end

  # Returns the file object for the given object's class.
  #
  # @param object [Object] the object to get the file for
  # @return [File] the file object for the given object's class
  def file_for(object)
    name = object.class.to_s
    if @files.keys.include? object.class.to_s
      return @files[name]
    else
      @files[name] = File.open("db/#{name}.csv", 'w+')
      @files[name].puts object.instance_variables.join(',').gsub('@', '')
      return @files[name]
    end
  end
end

store = Store.new

(1..10).each do
  json = JsonPlaceholderAPI.get_random_todo_json
  todo = Todo.from(json)
  store.add(todo)
end

store.save