require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database 
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end 

end

class User
    attr_accessor :id, :fname, :lname

    def self.all
        all_data = QuestionsDatabase.instance.execute('SELECT * FROM users')
        all_data.map{|sub_data| User.new(sub_data)}
    end

    def initialize(data)
        @id = data['id']
        @fname = data['fname']
        @lname = data['lname']
    end

    def self.find_by_id(id)
        query_id = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT *
            FROM users
            WHERE id = ?
        SQL

        query_id.map{|hash| User.new(hash)}.first
    end

    def self.find_by_name(fname, lname)
        name_query = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
            SELECT *
            FROM users
            WHERE fname = ? AND lname = ?
        SQL
        name_query.map{|hash| User.new(hash)}
    end

    def authored_questions
        Question.find_by_author_id(id)
    end

    def authored_replies
        Reply.find_by_user_id(id)
    end
end


class Question
    attr_accessor :id, :title, :body, :user_id

    def self.all
        all_data = QuestionsDatabase.instance.execute('SELECT * FROM questions')
        all_data.map{|sub_data| Question.new(sub_data)}
    end

    def initialize(data)
        @id = data['id']
        @title = data['title']
        @body = data['body']
        @user_id = data['user_id']
    end

    def self.find_by_id(id)
       id_query = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT *
            FROM questions
            WHERE id = ?
        SQL
        id_query.map{|hash| Question.new(hash)}.first
    end

    def self.find_by_author_id(author_id)
        author_id_query = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT *
            FROM questions
            WHERE user_id = ?
        SQL
        author_id_query.map {|hash| Question.new(hash)}
    end

    def author
       User.find_by_id(user_id) 
    end

    def replies
        Reply.find_by_question_id(id)
    end
end

class QuestionFollow

    attr_accessor :id, :questions_id, :user_id

    def self.all
        all_data = QuestionsDatabase.instance.execute('SELECT * FROM question_follows')
        all_data.map{|sub_data| QuestionFollow.new(sub_data)}
    end

    def initialize(data)
        @id = data['id']
        @questions_id = data['questions_id']
        @user_id = data['user_id']
    end

    def self.find_by_id(id)
       id_query = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT *
            FROM question_follows
            WHERE id = ?
        SQL
        id_query.map{|hash| QuestionFollow.new(hash)}.first
    end
end

class Reply
    attr_accessor :id, :questions_id, :parent_id, :user_id, :body
        def self.all
        all_data = QuestionsDatabase.instance.execute('SELECT * FROM replies')
        all_data.map{|sub_data| Reply.new(sub_data)}
    end

    def initialize(data)
        @id = data['id']
        @questions_id = data['questions_id']
        @parent_id = data['parent_id']
        @user_id = data['user_id']
        @body = data['body']
    end

    def self.find_by_id(id)
        id_query = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT *
            FROM replies
            WHERE id = ?
        SQL
        id_query.map{|hash| Reply.new(hash)}.first
    end

    def self.find_by_user_id(user_id)
        user_id_query = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT *
            FROM replies
            WHERE user_id = ?
        SQL
        user_id_query.map{|hash| Reply.new(hash)}
    end

    def self.find_by_question_id(questions_id)
        questions_id_query = QuestionsDatabase.instance.execute(<<-SQL, questions_id)
            SELECT *
            FROM replies
            WHERE questions_id = ?
        SQL
        questions_id_query.map{|hash| Reply.new(hash)}
    end

    def author
        Users.find_by_id(user_id)
    end

    def question
        Question.find_by_id(questions_id)
    end

    def parent_reply
        Question.find_by_id(parent_id)
    end

    # def child_replies
    #     Question.find_by_id(ch)
    # end
end

class QuestionLike
    attr_accessor :id, :questions_id, :user_id, :liked   
    def self.all
        all_data = QuestionsDatabase.instance.execute('SELECT * FROM question_likes')
        all_data.map{|sub_data| QuestionLike.new(sub_data)}
    end

    def initialize(data)
        @id = data['id']
        @questions_id = data['questions_id']
        @user_id = data['user_id']
        @liked = data['liked']
    end

    def self.find_by_id(id)
       id_query = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT *
            FROM questions_id
            WHERE id = ?
        SQL
        id_query.map{|hash| QuestionLike.new(hash)}.first
    end
end

u = Question.find_by_id(10)
p u.replies