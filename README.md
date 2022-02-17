# Student Enrollment System
## Deployed application link - https://student-enrollment-oodd.herokuapp.com
## Admin credentials
email - admin@admin.com
password - 123456

## User Registration & Login

Registration process inputs only basic information required for authentication purposes. It collects details which are common to all the users. At this point, user is not assigned to any role.

### User Registration
<img width="600" alt="Screenshot 2022-02-16 at 9 59 15 PM" src="https://media.github.ncsu.edu/user/24777/files/5489bd24-4761-4f29-9a57-ef4b3a5f01e7">

### User Login
<img width="494" alt="Screenshot 2022-02-16 at 9 59 52 PM" src="https://media.github.ncsu.edu/user/24777/files/e1c6215d-467c-408e-821d-ea454c9cc8b6">

### Role assignment after first login
<img width="720" alt="Screenshot 2022-02-16 at 10 00 01 PM" src="https://media.github.ncsu.edu/user/24777/files/9545e8f8-f922-407a-9b05-b2b0373fc8d8">

### Creating student role
<img width="735" alt="Screenshot 2022-02-16 at 10 00 39 PM" src="https://media.github.ncsu.edu/user/24777/files/753bed22-7777-4609-9110-4bf8da9ab03e">

<img width="758" alt="Screenshot 2022-02-16 at 10 00 51 PM" src="https://media.github.ncsu.edu/user/24777/files/c9e2a844-4d35-4ef4-84db-c6f2af256c22">



## Edge cases

### Automatic enrollment from waitlist:
When a student drops a course, destroy function of enrollment controller retreives all the waitlist records for that particular course and sorts it on the basis of created_at attribute. Then controller pops out the first record and creates an enrollment for it. Original enrollment is destroyed.

### Handling deletion of records in the children table:
When a Parent record is destroyed, it's corresponding children records from other table's are destroyed with dependents :destroy in the parent's model.

### Handling course status and capacity:

Each time course records are displayed, we are retrieving number of that particular course records from the enrollment table and subtracting that number from the original capacity to show users the number of seats left. For checking the number of waitlist positions left for that course, we retreive the number of that course's records from waitlist table and subtract it from the original waitlist capacity.

If there are seats left for a course, we keep the course status as open and display enroll button. If there are no seats left but waitlist positions are available, then we change the status to waitlist and display waitlist button. Otherwise we change the status to closed and donot display any button for enrollment/waitlist.

