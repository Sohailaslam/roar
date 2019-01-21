class Article < ActiveRecord::Base
    validates_presence_of :title, :body
    
    belongs_to :user
    has_and_belongs_to_many :categories
    has_many :comments
    
    scope :published, lambda {
            where("articles.published_at IS NOT NULL") }
    scope :draft, lambda {
                where("articles.published_at IS NULL") }
    scope :recent, lambda {
                published.where("articles.published_at > ?", 1.week.ago.to_date) }

    self.per_page = 6

    WillPaginate.per_page = 6
    
    def long_title
        "#{title} - #{published_at}"
    end
    
    def owned_by?(owner)
        return false unless owner.is_a?(User)
        user == owner
    end

     # return the threads whose titles contain one or more words that form the query
    def self.search(query)
        where("title like ?", "%#{query}%") 
    end

    def self.category_search(query)
        where("article.categories.category_id = ?", query) 
    end
end
