class PaginableScope

  attr_accessor :range, :collection

  def initialize(collection, range)
    @collection = collection
    @range      = range
  end

  def all
    operator = range.inclusive ? ">=" : ">"
    if range.start_identifier
      self.collection = collection.where("#{range.attribute} #{operator} ?", range.start_identifier)
    end

    if range.end_identifier
      self.collection = collection.where("#{range.attribute} <= ?", range.end_identifier)
    end

    self.collection = collection.order("#{range.attribute} #{range.order}")
    self.collection = collection.limit(range.max)
    self.collection
  end
end
