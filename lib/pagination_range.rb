class PaginationRange

  DEFAULT_MAX                 = 200
  DEFAULT_ORDER               = :desc
  VALID_ORDERS                = [ :asc, :desc ]
  DEFAULT_ATTRIBUTE           = :id

  attr_reader :max, :max, :order, :attribute

  def initialize(header_string)
    attrs_hash = PaginationRange.parse(header_string)
    @max     = attrs_hash[:max]
    @order     = attrs_hash[:desc]
    @attribute = attrs_hash[:desc]
  end

  def self.parse(header_string)
    header_string = header_string.to_s
    range_string, max_order_string = header_string.split(";")
    max, order = parse_max_order(max_order_string)
    {
      max: max,
      order: DEFAULT_ORDER,
      attribute: DEFAULT_ATTRIBUTE,
    }
  end

  def self.parse_max_order(header_string)
    header_string = header_string.to_s
    max_order_hash = {}
    header_string.split(",").each do |header_substring|
      max_order_hash.merge!(Rack::Utils.parse_nested_query(header_substring.strip))
    end
    max = max_order_hash["max"].to_i
    max = DEFAULT_MAX if max == 0
    max
  end
end
