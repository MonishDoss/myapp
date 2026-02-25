package com.myapp;

/**
 * Student
 * -------
 * Plain JavaBean that mirrors one row in the `students` table.
 * No framework magic – just getters, setters, and a convenience constructor.
 */
public class Student {

    private int    id;
    private String name;
    private String email;
    private String course;

    // ── no-arg constructor (required by some JSP EL expressions) ──────────
    public Student() {}

    // ── convenience constructor (used in DAO when reading from ResultSet) ─
    public Student(int id, String name, String email, String course) {
        this.id     = id;
        this.name   = name;
        this.email  = email;
        this.course = course;
    }

    // ── getters ───────────────────────────────────────────────────────────
    public int    getId()     { return id;     }
    public String getName()   { return name;   }
    public String getEmail()  { return email;  }
    public String getCourse() { return course; }

    // ── setters ───────────────────────────────────────────────────────────
    public void setId(int id)          { this.id     = id;     }
    public void setName(String name)   { this.name   = name;   }
    public void setEmail(String email) { this.email  = email;  }
    public void setCourse(String c)    { this.course = c;      }
}