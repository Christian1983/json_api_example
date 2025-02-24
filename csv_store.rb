class CsvStore
  def initialize(attributes)
    @memory = []
    @files  = {}
    _tattributes = attributes
    
    Dir.mkdir('db') unless Dir.exist?('db')
  end

  def save
  end
end

binding.irb