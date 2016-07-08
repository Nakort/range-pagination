require 'rails_helper'

describe PaginationRange do

  let(:pagination_range) { PaginationRange.parse(header_string) }

  describe "#attribute" do
    context "with nil" do
      let(:header_string) { nil }
      it "should return the default" do
        expect(pagination_range.attribute).to eq(PaginationRange::DEFAULT_ATTRIBUTE)
      end
    end
    context "with a value" do
      context "with an invalid one" do
        let(:header_string) { "attribute ]my-app-001..my-app-999; max=a, order=ask"}
        it "should return the default" do
          expect(pagination_range.attribute).to eq(PaginationRange::DEFAULT_ATTRIBUTE)
        end
      end
      context "with a valid one" do
        let(:header_string) { "name ]my-app-001..my-app-999; max=10, order=asc"}
        it "should return the correct value" do
          expect(pagination_range.attribute).to eq(:name)
        end
      end
    end
  end

  describe "#start_identifier" do
    context "with nil" do
      let(:header_string) { nil }
      it "should return nil" do
        expect(pagination_range.start_identifier).to eq(nil)
      end
    end

    context "with no value" do
      let(:header_string) { "name ..my-app-999; max=10, order=asc"}
      it "should return nil" do
        expect(pagination_range.start_identifier).to eq(nil)
      end
    end
    context "with a value" do
      let(:header_string) { "name ]my-app-001..my-app-999; max=10, order=asc"}
      it "should return the correct value" do
        expect(pagination_range.start_identifier).to eq("my-app-001")
      end
    end
  end

  describe "#end_identifier" do
    context "with nil" do
      let(:header_string) { nil }
      it "should return the default" do
        expect(pagination_range.end_identifier).to eq(nil)
      end
    end
    context "with no value" do
      let(:header_string) { "name ]my-app-001..; max=10, order=asc"}
      it "should return the default" do
        expect(pagination_range.end_identifier).to eq(nil)
      end
    end
    context "with a value" do
      let(:header_string) { "name ]my-app-001..my-app-999; max=10, order=asc"}
      it "should return the correct value" do
        expect(pagination_range.end_identifier).to eq("my-app-999")
      end
    end
  end

  describe "#order" do
    context "with nil" do
      let(:header_string) { nil }
      it "should return the default" do
        expect(pagination_range.order).to eq(PaginationRange::DEFAULT_ORDER)
      end
    end
    context "with a value" do
      context "with an invalid one" do
        let(:header_string) { "name ]my-app-001..my-app-999; max=a, order=ask"}
        it "should return the default" do
          expect(pagination_range.order).to eq(PaginationRange::DEFAULT_ORDER)
        end
      end
      context "with a valid one" do
        let(:header_string) { "name ]my-app-001..my-app-999; max=10, order=asc"}
        it "should return the correct value" do
          expect(pagination_range.order).to eq(:asc)
        end
      end
    end
  end

  describe "#inclusive" do
    context "with nil" do
      let(:header_string) { nil }
      it "should return the default" do
        expect(pagination_range.inclusive).to eq(true)
      end
    end

    context "with an opening bracket" do
      let(:header_string) { "name [my-app-001..my-app-999; max=a, order=asc"}
      it "should return the default" do
        expect(pagination_range.inclusive).to eq(true)
      end
    end

    context "with a closing bracket" do
      let(:header_string) { "name ]my-app-001..my-app-999; max=a, order=asc"}
      it "should return the default" do
        expect(pagination_range.inclusive).to eq(false)
      end
    end

    context "with no bracket" do
      let(:header_string) { "name my-app-001..my-app-999; max=a, order=asc"}
      it "should return the default" do
        expect(pagination_range.inclusive).to eq(true)
      end
    end
  end

  describe "#max" do
    context "with nil" do
      let(:header_string) { nil }
      it "should return the default" do
        expect(pagination_range.max).to eq(PaginationRange::DEFAULT_MAX)
      end
    end
    context "with a value" do
      context "with an invalid one" do
        let(:header_string) { "name ]my-app-001..my-app-999; max=a, order=asc"}
        it "should return the default" do
          expect(pagination_range.max).to eq(PaginationRange::DEFAULT_MAX)
        end
      end

      context "with a higher number than the default" do
        let(:header_string) { "name ]my-app-001..my-app-999; max=250, order=asc"}
        it "should return the default" do
          expect(pagination_range.max).to eq(PaginationRange::DEFAULT_MAX)
        end
      end
      context "with a valid one" do
        let(:header_string) { "name ]my-app-001..my-app-999; max=10, order=asc"}

        it "should return the correct value" do
          expect(pagination_range.max).to eq(10)
        end
      end
    end
  end

  describe "#to_header" do
    let(:header_string) { "id ]my-app-001..my-app-999; max=10, order=desc"}

    it "should build the correct header string" do
      expect(pagination_range.to_header).to eq(header_string)
    end
  end
end
