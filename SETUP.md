# SETUP.md — Student CRUD Web App
> Complete setup guide for **Windows**, **macOS**, and **Linux**  
> No IDE. No build tool. Pure terminal + Tomcat.  
> Both JAR dependencies live inside `WEB-INF/lib/` — self-contained.

---

## Table of Contents
1. [Install JDK](#1-install-jdk)
2. [Install Apache Tomcat](#2-install-apache-tomcat)
3. [Install MySQL](#3-install-mysql)
4. [Create the Database](#4-create-the-database)
5. [Add JAR Files to WEB-INF/lib](#5-add-jar-files-to-web-inflib)
6. [Configure DB Credentials](#6-configure-db-credentials)
7. [Compile the Java Files](#7-compile-the-java-files)
8. [Deploy to Tomcat](#8-deploy-to-tomcat)
9. [Run the App](#9-run-the-app)
10. [Stop the App](#10-stop-the-app)
11. [Troubleshooting](#11-troubleshooting)

---

## 1. Install JDK

### Windows
1. Go to https://adoptium.net
2. Download **JDK 17 — Windows x64 `.msi` installer**
3. Run the installer — tick **"Set JAVA_HOME"** and **"Add to PATH"** during setup
4. Open a new **Command Prompt** and verify:
```cmd
java -version
javac -version
```

### macOS
```bash
# Using Homebrew (recommended)
brew install openjdk@17

# Link it so the system can find it
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk \
     /Library/Java/JavaVirtualMachines/openjdk-17.jdk

java -version
javac -version
```
> Don't have Homebrew? Install it first: https://brew.sh

### Linux (Ubuntu / Debian)
```bash
sudo apt update
sudo apt install openjdk-17-jdk -y
java -version
javac -version
```

### Linux (Fedora / RHEL / CentOS)
```bash
sudo dnf install java-17-openjdk-devel -y
java -version
javac -version
```

---

## 2. Install Apache Tomcat

Download Tomcat 10 from https://tomcat.apache.org/download-10.cgi  
Pick the **"Core"** zip (Windows) or tar.gz (macOS / Linux).

### Windows
1. Download the **Windows zip** (`apache-tomcat-10.x.x-windows-x64.zip`)
2. Extract it to `C:\tomcat`
3. Open **System Properties → Environment Variables**
4. Add a new **System variable**:
   - Name: `TOMCAT_HOME`
   - Value: `C:\tomcat`
5. Verify in a new Command Prompt:
```cmd
dir %TOMCAT_HOME%\lib\servlet-api.jar
```

### macOS
```bash
cd ~
tar -xzf ~/Downloads/apache-tomcat-10.x.x.tar.gz
sudo mv apache-tomcat-10.x.x /opt/tomcat
sudo chmod +x /opt/tomcat/bin/*.sh

# Add to ~/.zshrc to make permanent
export TOMCAT_HOME=/opt/tomcat

ls $TOMCAT_HOME/lib/servlet-api.jar   # verify
```

### Linux
```bash
cd /opt
sudo tar -xzf ~/Downloads/apache-tomcat-10.x.x.tar.gz
sudo mv apache-tomcat-10.x.x tomcat
sudo chmod +x /opt/tomcat/bin/*.sh

# Add to ~/.bashrc to make permanent
echo 'export TOMCAT_HOME=/opt/tomcat' >> ~/.bashrc
source ~/.bashrc

ls $TOMCAT_HOME/lib/servlet-api.jar   # verify
```

---

## 3. Install MySQL

### Windows
1. Download **MySQL Installer** from https://dev.mysql.com/downloads/installer/
2. Run the installer → choose **"Developer Default"**
3. Follow the wizard — set a **root password** and remember it
4. Verify:
```cmd
mysql --version
```

### macOS
```bash
brew install mysql
brew services start mysql
mysql_secure_installation   # set root password here
mysql --version
```

### Linux (Ubuntu / Debian)
```bash
sudo apt install mysql-server -y
sudo systemctl start mysql
sudo systemctl enable mysql
sudo mysql_secure_installation
mysql --version
```

### Linux (Fedora / RHEL)
```bash
sudo dnf install mysql-server -y
sudo systemctl start mysqld
sudo systemctl enable mysqld
# Find the temporary root password:
sudo grep 'temporary password' /var/log/mysqld.log
mysql --version
```

---

## 4. Create the Database

Same on all platforms — run from the `myapp/` folder:

```bash
# macOS / Linux
mysql -u root -p < schema.sql

# Windows (Command Prompt)
mysql -u root -p < schema.sql
```

Enter your MySQL root password when prompted.

**Verify it worked:**
```sql
mysql -u root -p
USE studentdb;
SELECT * FROM students;
-- Should show 3 sample rows
EXIT;
```

---

## 5. Add JAR Files to WEB-INF/lib

This is the key step. Both dependency JARs must be placed in `WEB-INF/lib/`  
**before** compiling. The `compile.sh` script reads them from there automatically.

### JAR 1 — servlet-api.jar  
This comes bundled with Tomcat. Just copy it from Tomcat into the project:

**macOS / Linux**
```bash
cp $TOMCAT_HOME/lib/servlet-api.jar  myapp/WEB-INF/lib/
```

**Windows**
```cmd
copy %TOMCAT_HOME%\lib\servlet-api.jar  myapp\WEB-INF\lib\
```

---

### JAR 2 — mysql-connector-j-*.jar  
This is the JDBC driver that lets Java talk to MySQL.

1. Go to https://dev.mysql.com/downloads/connector/j/
2. Select **"Platform Independent"** from the dropdown
3. Download the `.zip` (Windows) or `.tar.gz` (macOS/Linux)
4. Extract it — find the file named `mysql-connector-j-8.x.x.jar`

**macOS / Linux**
```bash
cp mysql-connector-j-8.x.x.jar  myapp/WEB-INF/lib/
```

**Windows**
```cmd
copy mysql-connector-j-8.x.x.jar  myapp\WEB-INF\lib\
```

---

### Verify both JARs are in place

Your `WEB-INF/lib/` folder should now look like this:

```
WEB-INF/
└── lib/
    ├── servlet-api.jar
    └── mysql-connector-j-8.x.x.jar
```

> **Why `WEB-INF/lib/` and not `$TOMCAT_HOME/lib/`?**  
> Placing JARs inside the project folder makes it self-contained.  
> Anyone who clones the repo can compile without needing a Tomcat installation on their PATH.  
> Tomcat also automatically picks up JARs in `WEB-INF/lib/` at runtime.

---

## 6. Configure DB Credentials

Open `WEB-INF/classes/DBConnection.java` in any text editor and set your password:

```java
private static final String USER = "root";
private static final String PASS = "your_password_here";  // ← change this
```

Save the file. Recompile in the next step.

---

## 7. Compile the Java Files

Run from **inside the `myapp/` directory**.

### macOS / Linux
```bash
cd myapp
chmod +x compile.sh
./compile.sh
```

### Windows (Command Prompt)

Windows uses `;` as the classpath separator instead of `:`. Run `javac` directly:

```cmd
cd myapp

javac -classpath "WEB-INF\lib\servlet-api.jar;WEB-INF\lib\mysql-connector-j-8.x.x.jar" ^
      -d WEB-INF\classes ^
      WEB-INF\classes\DBConnection.java ^
      WEB-INF\classes\Student.java ^
      WEB-INF\classes\StudentDAO.java ^
      WEB-INF\classes\StudentServlet.java
```

> Replace `mysql-connector-j-8.x.x.jar` with your actual filename.

**Expected output:**
```
[INFO] Found: WEB-INF/lib/servlet-api.jar
[INFO] Found: WEB-INF/lib/mysql-connector-j-8.x.x.jar
[INFO] Compiling Java sources ...

[OK] Compilation successful.
```

After compiling you will see `.class` files alongside the `.java` files in `WEB-INF/classes/`.

> **Tomcat 9 users:** `StudentServlet.java` uses `jakarta.servlet.*` (Tomcat 10+).  
> If you are on **Tomcat 9**, change both import lines to `javax.servlet.*` before compiling.

---

## 8. Deploy to Tomcat

Copy the entire `myapp/` folder into Tomcat's `webapps/` directory.

### macOS / Linux
```bash
sudo cp -r myapp/ $TOMCAT_HOME/webapps/
```

### Windows
```cmd
xcopy /E /I myapp %TOMCAT_HOME%\webapps\myapp
```

Your final layout inside `webapps/myapp/` should look like:

```
webapps/
└── myapp/
    ├── index.jsp
    ├── student-list.jsp
    ├── student-form.jsp
    └── WEB-INF/
        ├── web.xml
        ├── lib/
        │   ├── servlet-api.jar
        │   └── mysql-connector-j-*.jar
        └── classes/
            ├── DBConnection.class
            ├── Student.class
            ├── StudentDAO.class
            └── StudentServlet.class
```

---

## 9. Run the App

### Windows
```cmd
%TOMCAT_HOME%\bin\startup.bat
```

### macOS / Linux
```bash
$TOMCAT_HOME/bin/startup.sh
```

**Watch the startup log:**
```bash
# macOS / Linux
tail -f $TOMCAT_HOME/logs/catalina.out

# Windows PowerShell
Get-Content "$env:TOMCAT_HOME\logs\catalina.out" -Wait
```

Once you see `Server startup in [X] milliseconds`, open:

```
http://localhost:8080/myapp/
```

You should see the student list with 3 records from the seed data.

---

## 10. Stop the App

### Windows
```cmd
%TOMCAT_HOME%\bin\shutdown.bat
```

### macOS / Linux
```bash
$TOMCAT_HOME/bin/shutdown.sh
```

---

## 11. Troubleshooting

| Problem | Likely cause | Fix |
|---------|-------------|-----|
| `javac: command not found` | JDK not on PATH | Re-open terminal after install; check `java -version` |
| `servlet-api.jar not found` | Not copied to `WEB-INF/lib/` | `cp $TOMCAT_HOME/lib/servlet-api.jar WEB-INF/lib/` |
| `mysql-connector-j-*.jar not found` | Not copied to `WEB-INF/lib/` | Copy JAR from download to `WEB-INF/lib/` |
| `cannot find symbol: jakarta.servlet` | Using Tomcat 9 | Change imports to `javax.servlet.*` and recompile |
| `ClassNotFoundException: com.mysql.cj.jdbc.Driver` | Connector/J missing from `WEB-INF/lib/` | Copy JAR there and restart Tomcat |
| `Access denied for user 'root'` | Wrong password in `DBConnection.java` | Update `PASS`, recompile, redeploy |
| `Communications link failure` | MySQL not running | `sudo systemctl start mysql` or start MySQL service |
| `HTTP 404` on `/myapp/` | App folder not deployed | Check `webapps/myapp/WEB-INF/web.xml` exists |
| `HTTP 500` Internal Server Error | Java runtime exception | Read `$TOMCAT_HOME/logs/catalina.out` for stack trace |
| Port 8080 already in use | Another app on port 8080 | Edit `$TOMCAT_HOME/conf/server.xml` → change `port="8080"` |

---

## Quick Reference — All Commands

```bash
# ── 1. Copy JARs into project ────────────────────────────────────
cp $TOMCAT_HOME/lib/servlet-api.jar   myapp/WEB-INF/lib/
cp mysql-connector-j-*.jar            myapp/WEB-INF/lib/

# ── 2. Create DB ─────────────────────────────────────────────────
mysql -u root -p < schema.sql

# ── 3. Set password ──────────────────────────────────────────────
# Edit WEB-INF/classes/DBConnection.java  →  PASS = "yourpassword"

# ── 4. Compile ───────────────────────────────────────────────────
cd myapp && chmod +x compile.sh && ./compile.sh

# ── 5. Deploy ────────────────────────────────────────────────────
cp -r myapp/ $TOMCAT_HOME/webapps/

# ── 6. Start ─────────────────────────────────────────────────────
$TOMCAT_HOME/bin/startup.sh

# ── 7. Open ──────────────────────────────────────────────────────
# http://localhost:8080/myapp/

# ── 8. Stop ──────────────────────────────────────────────────────
$TOMCAT_HOME/bin/shutdown.sh
```
