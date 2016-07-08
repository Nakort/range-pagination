class PaginableScope

  attr_accessor :range, :collection, :_all

  def initialize(collection, range)
    @collection = collection
    @range      = range
  end

  def all
    return self._all if self._all
    operator = range.inclusive ? ">=" : ">"
    self._all = collection
    if range.start_identifier.present?
      self._all = _all.where("#{range.attribute} #{operator} ?", range.start_identifier)
    end
    if range.end_identifier.present?
      self._all = _all.where("#{range.attribute} <= ?", range.end_identifier)
    end
    self._all = _all.order("#{range.attribute} #{range.order}")
    self._all = _all.limit(range.max)
    self._all
  end

  def next_range
    attrs_hash = {
      max: range.max,
      order: range.order,
      attribute: range.attribute,
      start_identifier: all.last.send(range.attribute),
      end_identifier: nil,
      inclusive: false
    }
    PaginationRange.new(attrs_hash)
  end

  def content_range
    attrs_hash = {
      max: range.max,
      order: range.order,
      attribute: range.attribute,
      start_identifier: all.first.send(range.attribute),
      end_identifier: all.last.send(range.attribute),
      inclusive: true
    }
    PaginationRange.new(attrs_hash)
  end
end
