module Wowza
  module REST
    class Instance

      include ActiveRecord::AttributeAssignment

      attr_accessor :incoming_streams, :name, :conn

      def initialize(attributes={})
        assign_attributes(attributes) if attributes
        super()
      end

      def attributes
        {
          name: name
        }
      end

    end
  end
end
