package com.myapp;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * StudentServlet  –  the single Controller in this MVC app
 * ---------------------------------------------------------
 * All requests hit  /students  with a  ?action=  parameter
 * that tells the servlet what to do.
 *
 *   action=list    → show all students  (default)
 *   action=new     → show blank add-form
 *   action=insert  → save new student to DB, redirect to list
 *   action=edit    → show pre-filled edit-form for ?id=N
 *   action=update  → save edited student to DB, redirect to list
 *   action=delete  → delete student ?id=N, redirect to list
 */
public class StudentServlet extends HttpServlet {

    private StudentDAO dao;

    @Override
    public void init() {
        dao = new StudentDAO();
    }

    // ── GET handler ────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {

                case "new":
                    // just forward to the empty form
                    req.getRequestDispatcher("/student-form.jsp").forward(req, res);
                    break;

                case "edit":
                    int id = Integer.parseInt(req.getParameter("id"));
                    Student s = dao.getStudentById(id);
                    req.setAttribute("student", s);
                    req.getRequestDispatcher("/student-form.jsp").forward(req, res);
                    break;

                case "delete":
                    dao.deleteStudent(Integer.parseInt(req.getParameter("id")));
                    res.sendRedirect(req.getContextPath() + "/students?action=list");
                    break;

                default: // "list"
                    List<Student> students = dao.getAllStudents();
                    req.setAttribute("students", students);
                    req.getRequestDispatcher("/student-list.jsp").forward(req, res);
                    break;
            }

        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }

    // ── POST handler  (handles insert & update form submissions) ──────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        Student s = new Student();
        s.setName  (req.getParameter("name"));
        s.setEmail (req.getParameter("email"));
        s.setCourse(req.getParameter("course"));

        try {
            if ("insert".equals(action)) {
                dao.addStudent(s);

            } else if ("update".equals(action)) {
                s.setId(Integer.parseInt(req.getParameter("id")));
                dao.updateStudent(s);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }

        res.sendRedirect(req.getContextPath() + "/students?action=list");
    }
}