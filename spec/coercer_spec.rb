require_relative "./spec_helper"

describe Gourami::Coercer do
  let(:coercer) { Class.new.extend(Gourami::Coercer) }

  describe "#coerce_string" do
    describe "options" do
      describe ":allow_nil" do
        it "when not provided returns nil" do
          assert_nil(coercer.coerce_string(nil))
        end

        it "when true returns nil" do
          assert_nil(coercer.coerce_string(nil, :allow_nil => true))
        end

        it "when empty string returns empty string" do
          assert_equal("", coercer.coerce_string("", :allow_nil => true))
        end

        it "when empty string and nil_when_empty is true returns nil" do
          assert_nil(coercer.coerce_string("", :allow_nil => true, :nil_when_empty => true))
        end

        it "when false converts to string" do
          assert_equal("", coercer.coerce_string(nil, :allow_nil => false))
        end
      end

      describe ":strip" do
        let(:input) { " foo " }

        it "strips by defaults" do
          assert_equal("foo", coercer.coerce_string(input))
        end

        it "strips when option is true" do
          assert_equal("foo", coercer.coerce_string(input, :strip => true))
        end

        it "does not strip when option is false" do
          assert_equal(input, coercer.coerce_string(input, :strip => false))
        end
      end
    end
  end

  describe "#coerce_boolean" do
    describe "options" do
      describe ":allow_nil" do
        it "when not provided returns false" do
          assert_equal(false, coercer.coerce_boolean(nil))
        end

        it "when true returns nil" do
          assert_nil(coercer.coerce_boolean(nil, :allow_nil => true))
        end

        it "when true and given empty string returns nil" do
          assert_nil(coercer.coerce_boolean("", :allow_nil => true))
        end

        it "when false and given empty string returns false" do
          assert_equal(false, coercer.coerce_boolean("", :allow_nil => false))
        end

        it "when false converts to string" do
          assert_equal(false, coercer.coerce_boolean(nil, :allow_nil => false))
        end

        it "when true returns true" do
          assert_equal(true, coercer.coerce_boolean(true))
        end

        it "when false returns false" do
          assert_equal(false, coercer.coerce_boolean(false))
        end
      end
    end
  end

  describe "#coerce_phone" do
    describe "options" do
      describe ":allow_nil" do
        it "when not provided returns nil" do
          assert_nil(coercer.coerce_phone(nil))
        end

        it "when true returns nil" do
          assert_nil(coercer.coerce_phone(nil, :allow_nil => true))
        end

        it "when true and given empty string returns empty string" do
          assert_equal("", coercer.coerce_phone("", :allow_nil => true))
        end

        it "when true and given empty string and nil_when_empty is true returns nil" do
          assert_nil(coercer.coerce_phone("", :allow_nil => true, :nil_when_empty => true))
        end

        it "when false and given empty string returns empty string" do
          assert_equal("", coercer.coerce_phone("", :allow_nil => false))
        end

        it "when false converts to string" do
          assert_equal("", coercer.coerce_phone(nil, :allow_nil => false))
        end
      end
    end
  end

  describe "#coerce_array" do
    describe "options" do
      let(:coercer_options) { { :element_type => element_type } }

      let(:input) { {
        12345 => {
          :key => :value
        }
      } }

      subject { coercer.coerce_array(input, coercer_options) }

      describe ":allow_nil" do
        let(:coercer_options) { { :element_type => element_type, :allow_nil => true } }

        it "when not provided returns empty array" do
          assert_equal([], coercer.coerce_array(nil))
        end

        it "when true returns nil" do
          assert_nil(coercer.coerce_array(nil, :allow_nil => true))
        end

        it "when false converts to empty array" do
          assert_equal([], coercer.coerce_array(nil, :allow_nil => false))
        end
      end

      describe "when :element_type is a Symbol" do
        let(:element_type) { :hash }

        it "converts to an Array but does not coerce :key_type or :value_type" do
          expected = [{
            :key => :value
          }]
          assert_equal(expected, subject)
        end
      end

      describe "when :element_type is a Hash" do
        let(:element_type) { {
          :type => :hash, :key_type => :string, :value_type => :string
        } }

        it "uses the :key_type and :value_type options to each child" do
          expected = [{
            "key" => "value"
          }]
          assert_equal(expected, subject)
        end
      end
    end
  end

  describe "#coerce_hash" do
    describe "options" do
      let(:coercer_options) { { :key_type => :integer, :value_type => { :type => :hash, :key_type => :string, :value_type => :string } } }

      let(:input) { {
        "12345" => {
          :key => :value
        }
      } }

      subject { coercer.coerce_hash(input, coercer_options) }

      describe ":allow_nil" do
        let(:coercer_options) { { :key_type => :string, :value_type => :string, :allow_nil => true } }

        it "when not provided returns empty hash" do
          assert_equal({}, coercer.coerce_hash(nil))
        end

        it "when true returns nil" do
          assert_nil(coercer.coerce_hash(nil, :allow_nil => true))
        end

        it "when false converts to empty hash" do
          assert_equal({}, coercer.coerce_hash(nil, :allow_nil => false))
        end
      end

      it "uses the :key_type and :value_type options to all key/value pairs" do
        expected = {
          12345 => {
            "key" => "value"
          }
        }
        assert_equal(expected, subject)
      end
    end
  end
end
