module Mongoid
  module Concerns
    extend ActiveSupport::Concern
    
    module ClassMethods
      def concerned_with(*concerns)
        concerns.each do |concern|
          require_dependency "#{name.underscore}/#{concern}"
        end
      end
    end
  end
end



