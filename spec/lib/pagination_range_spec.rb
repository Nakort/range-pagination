require 'rails_helper'

describe PaginationRange do

  let(:range) { PaginationRange.new(header_string) }

  describe "#max" do
    context "with no value" do
      let(:header_string) { nil }
      it "should return the default" do
        expect(range.max).to eq(PaginationRange::DEFAULT_MAX)
      end
    end

    context "with a value" do
      context "with an invalid one" do
        let(:header_string) { "Range: name ]my-app-001..my-app-999; max=a, order=asc"}
        it "should return the default" do
          expect(range.max).to eq(PaginationRange::DEFAULT_MAX)
        end
      end
      context "with a valid one" do
        let(:header_string) { "Range: name ]my-app-001..my-app-999; max=10, order=asc"}
        it "should return the default" do
          expect(range.max).to eq(10)
        end
      end
    end
  end
end
