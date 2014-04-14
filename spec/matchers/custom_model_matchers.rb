module CustomModelMatchers
  class ExistInDatabase
      def matches?(model)
        model.class.find(model)
        true
      rescue
        # ActiveRecord::RecordNotFound
        false
      end

      def failure_message
        "Object should exist in the database but doesn't"
      end
      
      def negative_failure_message
        "Object shouldn't exist in the database but does"
      end
    end
    
    def exist_in_database
      ExistInDatabase.new
    end
end