# Write a Python program enroll.py to add new students to the roster and enroll them in courses.
#
# Usage:
# $python3 enroll.py
# Name: Guy
# Course Code: ABCD
# No course with code ABCD
# Course Code: CS50
# Added Guy to CS50

from cs50 import get_string, SQL

database = SQL("sqlite:///students.db")

#add a person
name = get_string("Name: ")
student_id = database.execute("INSERT INTO people (name) VALUES (?)", name)

#prompt for courses to enroll in
while True:
    code = get_string("Course code: ")
    #if no input, then stop adding - TODO
    if not code:
        print("Invalid course code")
        break

    #query for course - TODO
    course = database.execute("SELECT id FROM courses WHERE code = (?)", code)

    #check to make sure course exists - TODO
    if course == '\0': #This block of code does not work 
        print(f"No course with code {code}")
        break
    #print(course) #course is a dictionary so we want course[0]['id']'

    #enroll student - TODO
    database.execute("INSERT INTO students (person_id, course_id) VALUES (?, ?)", student_id, course[0]['id'])
    print(f"Added {name}, {course[0]['id']}")
    break

# Q: How do i index into a dictionary in Python?
# A: results[0]["id"]
# Is the answer to two different problem sets

