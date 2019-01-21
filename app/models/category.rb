class Category < ActiveRecord::Base
    has_and_belongs_to_many :articles
    
    default_scope lambda { order('categories.name') }

    def self.get_category(query)
        where(id: query) 
    end
end
