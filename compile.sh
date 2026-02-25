#!/usr/bin/env bash
# =============================================================
#  compile.sh  –  compile all Java source files manually
#
#  BEFORE running this:
#    1. Copy mysql-connector-j-*.jar  →  WEB-INF/lib/
#    2. Copy servlet-api.jar          →  WEB-INF/lib/
#       (servlet-api.jar lives in $TOMCAT_HOME/lib/)
#
#  Run from inside the myapp/ directory:
#       chmod +x compile.sh
#       ./compile.sh
# =============================================================

set -e   # stop on first error

LIB="WEB-INF/lib"

# ── auto-detect jar files inside WEB-INF/lib/ ────────────────────────────
SERVLET_JAR=$(find "$LIB" -name "servlet-api.jar" 2>/dev/null | head -1)
MYSQL_JAR=$(find "$LIB" -name "mysql-connector-j-*.jar" \
                   -o -name "mysql-connector-java-*.jar" 2>/dev/null | head -1)

# ── validate both jars are present ───────────────────────────────────────
if [ -z "$SERVLET_JAR" ]; then
    echo ""
    echo "[ERROR] servlet-api.jar not found in $LIB/"
    echo "  Fix: cp \$TOMCAT_HOME/lib/servlet-api.jar $LIB/"
    echo ""
    exit 1
fi

if [ -z "$MYSQL_JAR" ]; then
    echo ""
    echo "[ERROR] mysql-connector-j-*.jar not found in $LIB/"
    echo "  Fix: download from https://dev.mysql.com/downloads/connector/j/"
    echo "       then: cp mysql-connector-j-*.jar $LIB/"
    echo ""
    exit 1
fi

echo "[INFO] Found: $SERVLET_JAR"
echo "[INFO] Found: $MYSQL_JAR"

# ── classpath (colon = Mac/Linux separator) ───────────────────────────────
CLASSPATH="$SERVLET_JAR:$MYSQL_JAR"

SRC="WEB-INF/classes"
OUT="WEB-INF/classes"

echo "[INFO] Creating package directory ..."
mkdir -p "$OUT/com/myapp"

echo "[INFO] Compiling Java sources ..."

javac \
  -classpath "$CLASSPATH" \
  -sourcepath "$SRC"      \
  -d "$OUT"               \
  "$SRC/DBConnection.java"    \
  "$SRC/Student.java"         \
  "$SRC/StudentDAO.java"      \
  "$SRC/StudentServlet.java"

echo ""
echo "[OK] Compilation successful."
echo ""
echo "── Next steps ──────────────────────────────────────────────"
echo "  1. Copy myapp/ to  \$TOMCAT_HOME/webapps/"
echo "  2. Start Tomcat:   \$TOMCAT_HOME/bin/startup.sh"
echo "  3. Open browser:   http://localhost:8080/myapp/"
echo "────────────────────────────────────────────────────────────"
