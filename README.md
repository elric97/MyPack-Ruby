# Student Enrollment System
### Deployed application link - https://student-enrollment-oodd.herokuapp.com
### Steps to run the program
* Clone this repository
```
git clone https://github.ncsu.edu/gkogant/CSC_ECE_517_Program_2.git
```
* Go to the directory
```
CSC_ECE_517_Program_2
```
* Install required gems
```
bundle install
```
* Run database migration on your system
```
rails db:migrate
```
* If webpacker is not installed on the system, run
```
rails webpacker:install
```
* Run seed for the setting up required data (Only Admin will be created initially)
```
rails db:seed
```
* Finally, run the rails server
```
rails server
```

### Admin credentials
email - admin@admin.com
password - 123456

### Technologies Used
* Ruby 3.0.3
* Rails 6.0.4
* PostgreSQL
* Heroku


### User Registration & Login

Registration process inputs only basic information required for authentication purposes. It collects details which are common to all the users. At this point, user is not assigned to any role.

Role can be chosen at a later stage when the user logs into the system. Here the user is given two option
* Student
* Instructor

Note: You won't be able to proceed further without choosing a role

<img width="400" alt="Screenshot 2022-02-16 at 9 59 15 PM" src="https://media.github.ncsu.edu/user/24777/files/5489bd24-4761-4f29-9a57-ef4b3a5f01e7">
<img width="400" alt="Screenshot 2022-02-16 at 10 00 01 PM" src="https://media.github.ncsu.edu/user/24777/files/9545e8f8-f922-407a-9b05-b2b0373fc8d8">


### Admin Flow

* There is only a single admin which has been created already
* Admin can see all the options available to him on Admin Panel
* Admin can add/update/delete instructors and students
* First admin will have to create a user and then assign role to that user.
* To add a course admin has to select a particular instructor and then add course for that instructor
* To enroll a student, admin can go to the courses page and then click on enroll to select student to be added to that course.

<img width="600" alt="Screen Shot 2022-02-16 at 23 36 08" src="https://media.github.ncsu.edu/user/22515/files/342cf26f-1b16-41cf-9ef1-efd2621c4c97">
<img width="600" alt="Screen Shot 2022-02-16 at 23 33 44" src="https://media.github.ncsu.edu/user/22515/files/faaf14f8-ca12-49a3-b000-71704667e6c6">

### Instructor Flow

* To login, click on the login button, to go to the login page; Entering valid credentials will take the instructor to the home page.
* In the home page, clicking on “your page”, will take the instructor to their respective user page.
* In the user page, instructor details are displayed. This page also has button provisions to edit the instructor details, view the instructor course, and add courses.
* Clicking the edit button on the home page, will redirect the instructor to the edit page where updatable details can be edited.
* Add course button will redirect the instructor to a new course page, where the instructor can create a new course.
* View courses will take the instructor to a page where all the courses under that particular instructor are displayed. Each course displayed will have show students, edit, destroy, enroll/waitlist buttons.
* Edit button will allow instructor to edit that course, destroy button will allow instructor to delete that course.
* Enroll/ waitlist buttons are displayed based on the course status. No button is displayed if the status is closed. Clicking that button will redirect to new enrollment and new waitlist page where they can add students to that course
* Show students button will display all the enrolled and waitlisted students, with remove student button to remove that student from either enrollment/ waitlist.
* Navigation bar can be used for the flow of the application.

### Student Flow
* Logging in with valid credentials will take students to the home page.
* Clicking on “your page” will take the student to their respective user page.
* This user page will show their respective details and has an edit option to update their profile.
* Students can see all the available courses by clicking on show all courses.
* Students can see their enrolled courses and the waitlisted courses clicking on the correct button. In the redirected page, they can remove themselves from the courses they are registered in.

<img width="600" alt="Screenshot 2022-02-16 at 10 00 51 PM" src="https://media.github.ncsu.edu/user/24777/files/c9e2a844-4d35-4ef4-84db-c6f2af256c22">


### Functionalities

* Instructor/Student can register and login on the portal.
* Instructor can create/update/delete courses for students.
* Instructor can enroll/waitlist/remove students from the courses where they are the owner.
* Instructor can also view the list of students enrolled/waitlisted in their courses.
* Student can enroll/waitlist/drop a course.
* Student can update their profile.
* Admin can do all the functionalities of Student and Instructor.
* A user can only be deleted by admin role.

### Edge cases

#### Admin Deletion
* Admin can update/delete any user he wants except the user with role admin, the only updation field for that user is name and phone number.

#### Capacity Updation
* Capacity can not be updated to a value that makes it negative with respect to current enrollment.

#### User profile access
* Users excpet admin are not allowed to access profile other than themseleves. Instructor can access other courses but cant unenroll students from that particular course.

#### Automatic enrollment from waitlist:
* When a student drops a course, destroy function of enrollment controller retreives all the waitlist records for that particular course and sorts it on the basis of created_at attribute. Then controller pops out the first record and creates an enrollment for it. Original enrollment is destroyed.

#### Handling deletion of records in the children table:
* When a Parent record is destroyed, it's corresponding children records from other table's are destroyed with dependents :destroy in the parent's model.

#### Handling course status and capacity:

* Each time course records are displayed, we are retrieving number of that particular course records from the enrollment table and subtracting that number from the original capacity to show users the number of seats left. For checking the number of waitlist positions left for that course, we retreive the number of that course's records from waitlist table and subtract it from the original waitlist capacity.

* If there are seats left for a course, we keep the course status as open and display enroll button. If there are no seats left but waitlist positions are available, then we change the status to waitlist and display waitlist button. Otherwise we change the status to closed and donot display any button for enrollment/waitlist.

