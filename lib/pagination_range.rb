class PaginationRange

  include Comparable

  DEFAULT_MAX                 = 200
  DEFAULT_ORDER               = :asc
  VALID_ORDERS                = [ :asc, :desc ]
  VALID_ATTRIBUTES            = [ :id, :name  ] 
  DEFAULT_ATTRIBUTE           = :id

  attr_reader :max, :max, :order, :attribute,
              :start_identifier, :end_identifier,
              :inclusive

  def initialize(attrs_hash={})
    @max              = attrs_hash[:max]
    @order            = attrs_hash[:order]
    @attribute        = attrs_hash[:attribute]
    @start_identifier = attrs_hash[:start_identifier]
    @end_identifier   = attrs_hash[:end_identifier]
    @inclusive        = attrs_hash[:inclusive]
  end

  def to_header
    "#{attribute} #{inclusive ? '' : ']'}#{start_identifier}..#{end_identifier}; max=#{max}, order=#{order}"
  end

  def self.parse(header_string)
    range_hash, max_order_hash = self.parse_header(header_string)
    attrs_hash = {
      max: max_for_header(max_order_hash),
      order: order_for_header(max_order_hash),
      attribute: attribute_for_header(range_hash),
      end_identifier: range_hash[:end].blank? ? nil : range_hash[:end],
      start_identifier: range_hash[:start].blank? ? nil : range_hash[:start],
      inclusive: range_hash[:inclusive] != "]"
    }
    PaginationRange.new(attrs_hash)
  end

  private

  def self.parse_header(header_string)
    range_hash = /\A(?<attribute>.*)\s+(?<inclusive>\]|\[)?(?<start>.*)\.\.(?<end>[^;]*);?\s*(?<params>.*)\z/.match(header_string)
    range_hash  = {:params => ""} if range_hash.blank?
    max_order_hash = Hash[range_hash[:params].scan(/(max|order)=(\d+|\w+)?,*/)]
    [range_hash, max_order_hash]
  end

  def self.attribute_for_header(range_hash)
    attribute = range_hash[:attribute].to_s.to_sym
    attribute = DEFAULT_ATTRIBUTE unless attribute.in?(VALID_ATTRIBUTES)
    attribute
  end

  def self.order_for_header(max_order_hash)
    order = max_order_hash["order"].to_s.to_sym
    order = DEFAULT_ORDER unless order.in?(VALID_ORDERS)
    order
  end

  def self.max_for_header(max_order_hash)
    max = max_order_hash.fetch("max", 0).to_i
    max = DEFAULT_MAX if max == 0 || max > DEFAULT_MAX
    max
  end

  def <=>(anOther)
    to_header <=> anOther.to_header
  end
end
