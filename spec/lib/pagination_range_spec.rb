require 'rails_helper'

describe PaginationRange do

  let(:range) { PaginationRange.new(header_string) }

  describe "#attribute" do
    context "with nil" do
      let(:header_string) { nil }
      it "should return the default" do
        expect(range.attribute).to eq(PaginationRange::DEFAULT_ATTRIBUTE)
      end
    end
    context "with a value" do
      context "with an invalid one" do
        let(:header_string) { "attribute ]my-app-001..my-app-999; max=a, order=ask"}
        it "should return the default" do
          expect(range.attribute).to eq(PaginationRange::DEFAULT_ATTRIBUTE)
        end
      end
      context "with a valid one" do
        let(:header_string) { "name ]my-app-001..my-app-999; max=10, order=asc"}
        it "should return the correct value" do
          expect(range.attribute).to eq(:name)
        end
      end
    end
  end

  describe "#start_identifier" do
    context "with nil" do
      let(:header_string) { nil }
      it "should return nil" do
        expect(range.start_identifier).to eq(nil)
      end
    end

    context "with no value" do
      let(:header_string) { "name ..my-app-999; max=10, order=asc"}
      it "should return nil" do
        expect(range.start_identifier).to eq(nil)
      end
    end
    context "with a value" do
      let(:header_string) { "name ]my-app-001..my-app-999; max=10, order=asc"}
      it "should return the correct value" do
        expect(range.start_identifier).to eq("my-app-001")
      end
    end
  end

  describe "#end_identifier" do
    context "with nil" do
      let(:header_string) { nil }
      it "should return the default" do
        expect(range.end_identifier).to eq(nil)
      end
    end
    context "with no value" do
      let(:header_string) { "name ]my-app-001..; max=10, order=asc"}
      it "should return the default" do
        expect(range.end_identifier).to eq(nil)
      end
    end
    context "with a value" do
      let(:header_string) { "name ]my-app-001..my-app-999; max=10, order=asc"}
      it "should return the correct value" do
        expect(range.end_identifier).to eq("my-app-999")
      end
    end
  end

  describe "#order" do
    context "with nil" do
      let(:header_string) { nil }
      it "should return the default" do
        expect(range.order).to eq(PaginationRange::DEFAULT_ORDER)
      end
    end
    context "with a value" do
      context "with an invalid one" do
        let(:header_string) { "name ]my-app-001..my-app-999; max=a, order=ask"}
        it "should return the default" do
          expect(range.order).to eq(PaginationRange::DEFAULT_ORDER)
        end
      end
      context "with a valid one" do
        let(:header_string) { "name ]my-app-001..my-app-999; max=10, order=asc"}
        it "should return the correct value" do
          expect(range.order).to eq(:asc)
        end
      end
    end
  end

  describe "#inclusive" do
    context "with nil" do
      let(:header_string) { nil }
      it "should return the default" do
        expect(range.inclusive).to eq(true)
      end
    end

    context "with an opening bracket" do
      let(:header_string) { "name [my-app-001..my-app-999; max=a, order=asc"}
      it "should return the default" do
        expect(range.inclusive).to eq(true)
      end
    end

    context "with a closing bracket" do
      let(:header_string) { "name ]my-app-001..my-app-999; max=a, order=asc"}
      it "should return the default" do
        expect(range.inclusive).to eq(false)
      end
    end

    context "with no bracket" do
      let(:header_string) { "name my-app-001..my-app-999; max=a, order=asc"}
      it "should return the default" do
        expect(range.inclusive).to eq(true)
      end
    end
  end

  describe "#max" do
    context "with nil" do
      let(:header_string) { nil }
      it "should return the default" do
        expect(range.max).to eq(PaginationRange::DEFAULT_MAX)
      end
    end
    context "with a value" do
      context "with an invalid one" do
        let(:header_string) { "name ]my-app-001..my-app-999; max=a, order=asc"}
        it "should return the default" do
          expect(range.max).to eq(PaginationRange::DEFAULT_MAX)
        end
      end
      context "with a valid one" do
        let(:header_string) { "name ]my-app-001..my-app-999; max=10, order=asc"}

        it "should return the correct value" do
          expect(range.max).to eq(10)
        end
      end
    end
  end
end
