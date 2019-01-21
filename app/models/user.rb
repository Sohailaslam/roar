# load the digest library containing the encryption routine
require 'digest'

class User < ActiveRecord::Base
    # create reader and writer methods for password
    # needed as password is no longer a field in the table
    attr_accessor :password
    
    validates_uniqueness_of :email
    validates_length_of :email, :within => 5..50
    validates_format_of :email, :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i, :multiline => true
    validates_confirmation_of :password
    
    has_one :profile
    has_many :articles, -> { order('published_at DESC, title ASC')},
                                    :dependent => :destroy
    
    has_many :replies, :through => :articles, :source => :comments
    
    # specify that the encrypt function is run before saving
    before_save :encrypt_new_password

    self.per_page = 10
    
    def self.authenticate(email, password)
        user = find_by_email(email)
        return user if user && user.authenticated?(password)
    end
    
    def authenticated?(password)
        self.hashed_password == encrypt(password)
    end
    
    protected
        # only encrypt if the password contains a value
        def encrypt_new_password
            return if password.blank?
            self.hashed_password = encrypt(password)
        end
    
        def password_required?
            hashed_password.blank? || password.present?
        end
    
        def encrypt(string)
            Digest::SHA1.hexdigest(string)
        end

        def create_profile
            Profile.create(user: self)
        end
end
