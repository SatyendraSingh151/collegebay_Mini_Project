# CollegeBay – Student Resource & Mentorship Portal

![Java](https://img.shields.io/badge/Java-ED8B00?style=flat&logo=java&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-Servlet-brightgreen)
![MySQL](https://img.shields.io/badge/MySQL-00000F?style=flat&logo=mysql&logoColor=white)
![Bootstrap](https://img.shields.io/badge/Bootstrap-563D7C?style=flat&logo=bootstrap&logoColor=white)
![Tomcat](https://img.shields.io/badge/Apache%20Tomcat-F8DC75?style=flat&logo=apache-tomcat&logoColor=black)

**CollegeBay** is a full-stack Java web application that connects college students to share study resources and seek mentorship. It enables a community-driven learning platform where students can buy/sell resources, request mentorship, and manage their academic connections.

**Project developed by:** Satyendra Singh  
**Contact:** 151satyendrasingh@gmail.com  
**GitHub:** [SatyendraSingh151](https://github.com/SatyendraSingh151)

---

## 🎯 Features

### 📚 Resource Marketplace
- **Post Resources**: Upload study materials, notes, PDFs with title, description, and price.
- **Browse Resources**: View all posted resources with owner details.
- **Posted By**: See who posted each resource (username visible).
- **Contact Owner**: Email integration to directly contact resource sellers.
- **Delete Resource**: Remove your own resources anytime.

### 👥 Student Directory
- **Student List**: View all registered students with pagination.
- **Student Profiles**: Click "View Profile" to see a student's details and resources.
- **Search**: Search students by name to find specific peers.

### 🤝 Mentorship System
- **Request Mentorship**: Send mentorship requests to any student with a custom message.
- **Mentor Dashboard**: Receive and manage incoming requests with quick reply options.
- **Quick Replies**: Mentors can respond with **Yes / No / Later**.
- **Mentee View**: See mentor's reply status in "My Mentorship Requests" section.
- **Delete Requests**: Both mentor and mentee can delete requests to keep the interface clean.

### 🔐 Account Management
- **Secure Registration**: Create account with username, email, and password.
- **Login Authentication**: Session-based user authentication.
- **Delete Account**: Permanently remove your profile, resources, and all mentorship data.

---

## 🛠 Tech Stack

| Component | Technology |
|-----------|-----------|
| Backend | Java 8+, JSP, Servlets, JDBC |
| Frontend | HTML5, CSS3, Bootstrap 5 |
| Database | MySQL 5.7+ |
| Server | Apache Tomcat 9.x / 10.x |
| Version Control | Git, GitHub |
| Build | Eclipse IDE |

---

## 📋 Database Schema

### Tables Created

#### 1. **users** table
CREATE TABLE users (
id INT AUTO_INCREMENT PRIMARY KEY,
username VARCHAR(50) UNIQUE NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
password VARCHAR(255) NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

text

#### 2. **resources** table
CREATE TABLE resources (
id INT AUTO_INCREMENT PRIMARY KEY,
title VARCHAR(200) NOT NULL,
description TEXT,
price DECIMAL(10,2),
seller_id INT NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (seller_id) REFERENCES users(id) ON DELETE CASCADE
);

text

#### 3. **mentorship_requests** table
CREATE TABLE mentorship_requests (
id INT AUTO_INCREMENT PRIMARY KEY,
mentor_id INT NOT NULL,
mentee_id INT NOT NULL,
message TEXT,
status VARCHAR(20) DEFAULT 'pending',
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (mentor_id) REFERENCES users(id) ON DELETE CASCADE,
FOREIGN KEY (mentee_id) REFERENCES users(id) ON DELETE CASCADE
);

text

---

## 🚀 Local Setup & Running

### Prerequisites
- Java 8 or higher
- Apache Tomcat 9.x / 10.x
- MySQL 5.7 or higher
- Eclipse IDE (or any Java IDE)
- Git

### Step 1: Database Setup

1. Open MySQL command line or MySQL Workbench.

2. Create database:
CREATE DATABASE collegebay CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE collegebay;

text

3. Execute all three CREATE TABLE commands (see schema above).

4. Verify tables:
SHOW TABLES;

text

### Step 2: Clone the Repository

git clone https://github.com/SatyendraSingh151/collegebay_Mini_Project.git
cd collegebay_Mini_Project

text

### Step 3: Configure Database Connection

1. Open the file: `src/main/java/com/collegebay/util/DBConnection.java`

2. Update the database credentials:
private static final String URL = "jdbc:mysql://localhost:3306/collegebay";
private static final String USER = "root"; // your MySQL username
private static final String PASS = "your_password"; // your MySQL password
private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

text

3. Save the file.

### Step 4: Import into Eclipse

1. Open Eclipse.
2. File → Import → Existing Projects into Workspace.
3. Select the cloned `collegebay_Mini_Project` folder.
4. Click Finish.

### Step 5: Add Tomcat Server

1. Window → Show View → Servers.
2. Right-click → New → Server.
3. Choose Apache Tomcat v9.0 (or v10.0).
4. Click Next and point to your Tomcat installation folder.
5. Add the CollegeBay project to the server.

### Step 6: Run the Application

1. Right-click the project → Run As → Run on Server.
2. Choose your Tomcat server.
3. Application opens at:
http://localhost:8080/Servlet_Technical_Round_Practice/login.jsp

text
(adjust context path if different)

---

## 🌐 Deployment on Cloud

### Option 1: Deploy on Heroku (Easiest)

1. Create `Procfile` in project root:
web: java $JAVA_OPTS -cp target/classes:target/lib/* -Dfile.encoding=UTF-8 org.apache.catalina.startup.Bootstrap

text

2. Create `system.properties`:
java.runtime.version=11
maven.version=3.6.2

text

3. Push to Heroku:
heroku login
heroku create collegebay-satyendra
git push heroku main
heroku addons:create cleardb:ignite
heroku open

text

### Option 2: Deploy on AWS Elastic Beanstalk (Enterprise)

1. Export as WAR from Eclipse:
- Right-click project → Export → WAR file → Save as `collegebay.war`

2. Install AWS EB CLI:
pip install awsebcli

text

3. Initialize EB:
eb init -p tomcat-9.0-java11 collegebay --region ap-south-1
eb create collegebay-env

text

4. Create RDS MySQL database in AWS Console:
- Engine: MySQL 5.7
- Instance class: db.t2.micro (free tier)
- Storage: 20 GB
- Region: Asia Pacific (Mumbai)

5. Update `DBConnection.java` with RDS endpoint:
private static final String URL = "jdbc:mysql://your-rds-endpoint.rds.amazonaws.com:3306/collegebay";

text

6. Deploy:
mvn clean package
eb deploy
eb open

text

### Option 3: Deploy on DigitalOcean (Simple & Affordable)

1. Create DigitalOcean droplet:
- OS: Ubuntu 20.04 LTS
- Size: $5/month
- Region: Bangalore (ap)

2. SSH into droplet:
ssh root@your_droplet_ip

text

3. Install Java & Tomcat:
apt update
apt install default-jdk tomcat9 mysql-server -y
systemctl start tomcat9
systemctl enable tomcat9

text

4. Create MySQL database:
mysql -u root -p
CREATE DATABASE collegebay CHARACTER SET utf8mb4;
(paste your CREATE TABLE queries)
EXIT;

text

5. Upload WAR file:
scp target/collegebay.war root@your_ip:/var/lib/tomcat9/webapps/

text

6. Restart Tomcat:
systemctl restart tomcat9

text

7. Access application:
http://your_droplet_ip:8080/collegebay

text

### Option 4: Deploy on Render (Free Tier)

1. Go to [Render.com](https://render.com)
2. Click "New Web Service"
3. Connect your GitHub repo: `collegebay_Mini_Project`
4. Configure:
- Runtime: Java 11
- Build command: `mvn clean package`
- Start command: `java -cp target/classes:target/lib/* org.apache.catalina.startup.Bootstrap`
5. Add MySQL database
6. Deploy and access at auto-generated URL

### Option 5: Deploy on Railway (Quick & Easy)

1. Go to [Railway.app](https://railway.app)
2. Create new project from GitHub
3. Select `collegebay_Mini_Project`
4. Configure:
- Runtime: Java 11
- Start: `java -jar target/collegebay.war --port=$PORT`
5. Add MySQL database
6. Deploy in 2-3 minutes

---

## 📁 Project Structure

collegebay_Mini_Project/
│
├── src/
│ └── main/
│ ├── java/com/collegebay/
│ │ ├── servlet/ (All Servlets)
│ │ └── util/ (DBConnection.java)
│ └── webapp/ (JSPs and static files)
│
├── WebContent/
│ ├── login.jsp
│ ├── register.jsp
│ ├── dashboard.jsp
│ ├── students.jsp
│ ├── profile.jsp
│ ├── addResource.jsp
│ └── css/
│
├── README.md
├── DEPLOYMENT.md
├── CONTRIBUTING.md
├── LICENSE
└── .gitignore

text

---

## 🔑 Key Servlets

| Servlet | Purpose |
|---------|---------|
| `LoginServlet.java` | User authentication and session management |
| `RegisterServlet.java` | New user registration with validation |
| `AddResourceServlet.java` | Create and store new resources |
| `DeleteResourceServlet.java` | Delete user's own resources |
| `StudentListServlet.java` | Fetch paginated student list |
| `ProfileServlet.java` | Display individual student profile with resources |
| `MentorshipRequestServlet.java` | Create mentorship request |
| `UpdateMentorRequestServlet.java` | Update request status (Yes/No/Later) |
| `DeleteMentorRequestServlet.java` | Delete mentorship request |
| `DeleteAccountServlet.java` | Delete user account and cascade data |
| `SearchStudentServlet.java` | Search students by name |
| `LogoutServlet.java` | Invalidate session and logout |

---

## 📸 User Flow

┌─────────────────┐
│ User Lands │
└────────┬────────┘
│
▼
┌─────────────────┐ ┌──────────────────┐
│ login.jsp │─────→ │ New User? │
└─────────────────┘ └────────┬─────────┘
│
┌────────┴────────┐
▼ ▼
┌──────────────┐ ┌─────────────┐
│register.jsp │ │ Login OK │
└──────┬───────┘ └────────┬────┘
│ │
└───────┬───────────┘
▼
┌──────────────────────┐
│ dashboard.jsp │
│ - Browse Resources │
│ - Mentorship Reqs │
│ - Add Resource │
└──────────┬───────────┘
│
┌──────────┴──────────┐
▼ ▼
┌───────────┐ ┌──────────────┐
│All Students│ │Add Resource │
│View Profile│ └──────────────┘
│Request Ship│
└────┬──────┘
│
▼
┌──────────────────┐
│Mentor Receives │
│Request & Replies │
│(Yes/No/Later) │
└────────┬─────────┘
│
▼
┌──────────────────┐
│Mentee Sees Reply │
│Status Updates │
└──────────────────┘

text

---

## 🧪 Testing Scenarios

### Scenario 1: Resource Marketplace Flow
1. Register as **User A**
2. Add a resource (title: "Calculus Notes", price: ₹100)
3. Logout and login as **User B**
4. See User A's resource on dashboard
5. Click "Ask for Resource" → Email client opens with pre-filled message
6. User A receives email and can respond with contact details

### Scenario 2: Mentorship Flow
1. Login as **User B**
2. Go to "All Students" → Search for User A
3. Click "View Profile" → Click "Request Mentorship"
4. Add message: "I need help with Data Structures"
5. Logout and login as **User A**
6. See "Mentorship Requests (You as Mentor)" card
7. Click **"Yes"** button
8. Logout and login as **User B**
9. See "My Mentorship Requests" card showing status: **"Yes"**
10. Delete the mentorship request if needed

### Scenario 3: Account Deletion
1. Login as **User C**
2. Add 2-3 resources
3. Send mentorship request to User A
4. Click "Delete My Account" → Confirm deletion
5. Account deleted; all resources and requests removed from database
6. Try logging in again → Access denied

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| "No suitable driver found for jdbc:mysql" | Add MySQL JDBC jar (`mysql-connector-java-8.0.x.jar`) to project's `lib` folder |
| "Access denied for user 'root'" | Check MySQL username/password in `DBConnection.java` matches your MySQL setup |
| 404 on login.jsp
