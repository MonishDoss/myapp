# 📚 Student CRUD Web App
**Internet Programming Class Project**

A Java web application demonstrating full **CRUD** (Create, Read, Update, Delete) operations with database connectivity — built entirely without an IDE or build tool, using a legacy flat-file project structure.

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Language | Java |
| Web Layer | Servlets + JSP |
| Database API | JDBC |
| Database | MySQL |
| Server | Apache Tomcat 10 |
| Architecture | MVC (Model-View-Controller) |
| Build | Manual — `javac` + `compile.sh` |

---

## 📁 Project Structure

```
myapp/
│
├── index.jsp                   ← Welcome page — redirects to student list
├── student-list.jsp            ← View: displays all students in a table
├── student-form.jsp            ← View: add / edit form (dual-purpose)
│
├── schema.sql                  ← MySQL setup — creates DB, table, seed data
├── compile.sh                  ← Shell script to compile all Java source files
│
└── WEB-INF/
    ├── web.xml                 ← Deployment descriptor — maps servlet to URL
    │
    ├── lib/                    ← ⚠️  PUT YOUR JAR FILES HERE
    │   ├── servlet-api.jar         (copy from $TOMCAT_HOME/lib/)
    │   └── mysql-connector-j-*.jar (download from MySQL website)
    │
    └── classes/
        ├── DBConnection.java   ← JDBC helper — holds connection settings
        ├── Student.java        ← Model: JavaBean mirroring the DB table
        ├── StudentDAO.java     ← Model: all SQL / CRUD operations
        └── StudentServlet.java ← Controller: handles all HTTP requests
```

> **Why `WEB-INF/lib/`?**  
> Keeping both JARs inside the project means anyone who clones the repo only needs to drop the JARs in one place — no system-level Tomcat path required to compile.

---

## ⚙️ MVC Architecture

```
Browser
   │
   ▼
StudentServlet.java  ← Controller
   │  reads ?action= parameter and decides what to do
   │
   ├──► StudentDAO.java   ← Model (talks to MySQL via JDBC)
   │        │
   │        └──► DBConnection.java  (opens the JDBC connection)
   │
   └──► *.jsp files       ← View (renders HTML sent to browser)
```

**Request flow example — editing a student:**
1. Browser sends `GET /students?action=edit&id=2`
2. `StudentServlet` reads `action=edit`, calls `StudentDAO.getStudentById(2)`
3. DAO queries MySQL, returns a `Student` object
4. Servlet puts it in the request scope, forwards to `student-form.jsp`
5. JSP renders the pre-filled form — browser displays it

---

## ✅ Features

- **List** all students in a clean HTML table
- **Add** a new student with a form
- **Edit** any existing student record
- **Delete** a student with a confirmation prompt
- Single servlet handles all actions via an `?action=` parameter
- Prepared statements used in DAO — prevents SQL injection
- Minimal, readable JSP with inline Java scriptlets (no JSTL dependency)
- Fully manual compilation — no Maven, Gradle, or IDE required

---

## 🚀 Quick Start

```bash
# 1. Drop the two JARs into WEB-INF/lib/
cp $TOMCAT_HOME/lib/servlet-api.jar    myapp/WEB-INF/lib/
cp mysql-connector-j-*.jar             myapp/WEB-INF/lib/

# 2. Create the database
mysql -u root -p < schema.sql

# 3. Set your DB password in WEB-INF/classes/DBConnection.java

# 4. Compile (from inside myapp/)
chmod +x compile.sh && ./compile.sh

# 5. Deploy
cp -r myapp/ $TOMCAT_HOME/webapps/

# 6. Start Tomcat
$TOMCAT_HOME/bin/startup.sh

# 7. Open in browser
# http://localhost:8080/myapp/
```

> For full platform-specific instructions (Windows, macOS, Linux) see **[SETUP.md](SETUP.md)**

---

## 📋 Prerequisites

- JDK 11 or 17
- Apache Tomcat 10.x *(for Tomcat 9, change `jakarta.servlet.*` imports to `javax.servlet.*`)*
- MySQL 8.x
- `servlet-api.jar` — copy from `$TOMCAT_HOME/lib/` → `WEB-INF/lib/`
- `mysql-connector-j-*.jar` — from https://dev.mysql.com/downloads/connector/j/ → `WEB-INF/lib/`

---

## 🗄️ Database Schema

```sql
CREATE TABLE students (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    email      VARCHAR(100) NOT NULL UNIQUE,
    course     VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 📖 What This Project Demonstrates

- Configuring a servlet using `web.xml` (no annotations)
- Using `HttpServletRequest` / `HttpServletResponse` in a servlet
- Passing data from servlet to JSP via `request.setAttribute()`
- Writing a DAO class with `PreparedStatement` for all CRUD operations
- Managing JDBC connections manually (open → use → close in `finally`)
- Dual-purpose JSP form (same file handles both add and edit)
- Post-Redirect-Get pattern to prevent duplicate form submissions
- Legacy flat-file deployment — no WAR packaging needed

---

## 👨‍💻 Author

@MonishDoss

---

Internet Programming Class Project  
Manual deployment — no IDE, no build framework
