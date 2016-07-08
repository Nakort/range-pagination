class PaginationRange

  DEFAULT_MAX                 = 200
  DEFAULT_ORDER               = :desc
  VALID_ORDERS                = [ :asc, :desc ]
  VALID_ATTRIBUTES            = [ :id, :name  ] 
  DEFAULT_ATTRIBUTE           = :id

  attr_reader :max, :max, :order, :attribute,
              :start_identifier, :end_identifier,
              :inclusive

  def initialize(header_string)
    attrs_hash        = PaginationRange.parse(header_string)
    @max              = attrs_hash[:max]
    @order            = attrs_hash[:order]
    @attribute        = attrs_hash[:attribute]
    @start_identifier = attrs_hash[:start_identifier]
    @end_identifier   = attrs_hash[:end_identifier]
    @inclusive        = attrs_hash[:inclusive]
  end

  def self.parse(header_string)
    header_string = header_string.to_s
    range_string, max_order_string = header_string.split(";")
    max, order = parse_max_order(max_order_string)
    attribute = parse_attribute(range_string)
    start_identifier, end_identifier, inclusive = parse_range(range_string)
    {
      max: max,
      order: order,
      attribute: attribute,
      end_identifier: end_identifier,
      start_identifier: start_identifier,
      inclusive: inclusive
    }
  end

  def self.parse_attribute(header_string)
    header_string = header_string.to_s
    attribute, _ = header_string.split(" ")
    attribute = attribute.to_s.to_sym
    attribute = DEFAULT_ATTRIBUTE unless attribute.in?(VALID_ATTRIBUTES)
    attribute
  end

  def self.parse_range(header_string)
    header_string = header_string.to_s
    inclusive = true
    _ , range = header_string.split(" ")
    return [ nil, nil, inclusive] if range.blank?
    start_identifier, end_identifier = range.split("..")
    return [ nil, end_identifier, inclusive] if start_identifier.blank?
    if start_identifier.starts_with?("]")
      inclusive = false
    end
    if start_identifier.starts_with?("]") || start_identifier.starts_with?("[") 
      start_identifier = start_identifier[1..-1]
    end
    [start_identifier, end_identifier, inclusive]
  end

  def self.parse_max_order(header_string)
    header_string = header_string.to_s
    max_order_hash = {}
    header_string.split(",").each do |header_substring|
      max_order_hash.merge!(Rack::Utils.parse_nested_query(header_substring.strip))
    end
    max   = max_order_hash["max"].to_i
    max   = DEFAULT_MAX if max == 0
    order = max_order_hash["order"].to_s.to_sym
    order = DEFAULT_ORDER unless order.in?(VALID_ORDERS)
    [max, order]
  end
end
