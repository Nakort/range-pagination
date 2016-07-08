require 'rails_helper'

describe PaginableScope do

  before(:all) do
    300.times.each do |i|
      App.create!(name: "my-app-#{i}")
    end
  end

  let(:collection)       { App.all }
  let(:range)            { PaginationRange.new(header_string) }
  let(:scope)            { PaginableScope.new(collection, range).all }
  let(:header_string)    { "#{attribute} #{start_identifier}..#{end_identifier};max=#{max} , order=#{order}"}
  let(:attribute)        { "name" }
  let(:start_identifier) { "my-app-10" }
  let(:end_identifier)   { "my-app-50" }
  let(:max)              { "20"    }
  let(:order)            { "desc" }

  describe "#all" do
    let(:comparable_scope) { 
      App.where("name >= ?", start_identifier)
         .where("name <= ?", end_identifier)
         .order("#{attribute} #{order}")
         .limit(max)
    }

    it "should return the objects according to the range" do
      expect(scope.map(&:id)).to eq(comparable_scope.map(&:id))
    end

    context "with an exclusive start identifier" do
      let(:start_identifier) { "]my-app-10" }
      let(:comparable_scope) { 
        App.where("#{attribute} > ?", start_identifier)
           .where("#{attribute} < ?", end_identifier)
           .order("#{attribute} #{order}")
           .limit(max)
      }
      it "should not include the first range object" do
        expect(scope.map(&:id)).to_not include(App.find_by!(name: start_identifier[1..-1]).id)
      end
    end

    context "with no end identifier" do
      let(:end_identifier) { nil }
      let(:comparable_scope) { 
        App.where("#{attribute} >= ?", start_identifier).order("#{attribute} #{order}").limit(max)
      }
      it "should return objects starting at that position" do
        expect(scope.map(&:id)).to eq(comparable_scope.map(&:id))
      end
    end

    context "with no max" do
      let(:max) { nil }

      it "should return objects starting at that position" do
        expect(scope.count).to eq(PaginationRange::DEFAULT_MAX)
      end
    end

    context "with no order" do
      let(:order) { "" }
      let(:comparable_scope) { 
        App.where("name >= ?", start_identifier)
          .where("name <= ?", end_identifier)
          .order("#{attribute} #{PaginationRange::DEFAULT_ORDER}")
          .limit(max)
      }

      it "should order by the default order" do
        expect(scope.map(&:id)).to eq(comparable_scope.map(&:id))
      end
    end

    context "with a higher max" do
      let(:max) { 300 }

      it "should return objects starting at that position" do
        expect(scope.count).to eq(PaginationRange::DEFAULT_MAX)
      end
    end

    context "with no start identifier and no end identifier" do
      let(:start_identifier) { }
      let(:end_identifier)   { }
      let(:comparable_scope) { 
        App.order("#{attribute} #{order}").limit(max)
      }

      it "should return objects starting at that position" do
        expect(scope.map(&:id)).to eq(comparable_scope.map(&:id))
      end
    end
  end
end
