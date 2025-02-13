require "pry"

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL

    DB[:conn].execute(sql).map do |student|
      self.new_from_db(student)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |student|
      self.new_from_db(student)
    end.last
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT COUNT(*) FROM students WHERE grade = 9
    SQL

    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    below_12th = []

    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12
    SQL

    DB[:conn].execute(sql).map do |student|
      below_12th << self.new_from_db(student)
    end
    below_12th
  end

  def self.first_x_students_in_grade_10(num)
    grade_10 = []

    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT ?
    SQL

    DB[:conn].execute(sql, num).map do |student|
      grade_10 << self.new_from_db(student)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT 1
    SQL

    student = DB[:conn].execute(sql)[0]
    self.new_from_db(student)
  end

  def self.all_students_in_grade_x(num)
    x_grade = []

    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL

    DB[:conn].execute(sql, num).map do |student|
      x_grade << self.new_from_db(student)
    end
    x_grade
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
