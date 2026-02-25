<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.myapp.Student" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Student Records</title>
  <style>
    body        { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
    h2          { color: #333; }
    a.btn       { display:inline-block; padding:6px 14px; background:#4CAF50;
                  color:#fff; text-decoration:none; border-radius:4px; margin-bottom:16px; }
    a.btn:hover { background:#45a049; }
    table       { width:100%; border-collapse:collapse; background:#fff;
                  box-shadow:0 1px 4px rgba(0,0,0,.15); }
    th          { background:#4CAF50; color:#fff; padding:10px 14px; text-align:left; }
    td          { padding:9px 14px; border-bottom:1px solid #ddd; }
    tr:hover td { background:#f0f9f0; }
    .edit       { color:#2196F3; text-decoration:none; margin-right:8px; }
    .delete     { color:#f44336; text-decoration:none; }
    .empty      { color:#888; font-style:italic; padding:12px; }
  </style>
</head>
<body>

<h2>Student Records</h2>
<a class="btn" href="students?action=new">+ Add New Student</a>

<%
  @SuppressWarnings("unchecked")
  List<Student> students = (List<Student>) request.getAttribute("students");
%>

<table>
  <thead>
    <tr>
      <th>#</th><th>Name</th><th>Email</th><th>Course</th><th>Actions</th>
    </tr>
  </thead>
  <tbody>
    <% if (students == null || students.isEmpty()) { %>
      <tr><td class="empty" colspan="5">No students found.</td></tr>
    <% } else {
         for (Student st : students) { %>
      <tr>
        <td><%= st.getId()     %></td>
        <td><%= st.getName()   %></td>
        <td><%= st.getEmail()  %></td>
        <td><%= st.getCourse() %></td>
        <td>
          <a class="edit"
             href="students?action=edit&id=<%= st.getId() %>">Edit</a>
          <a class="delete"
             href="students?action=delete&id=<%= st.getId() %>"
             onclick="return confirm('Delete <%= st.getName() %>?')">Delete</a>
        </td>
      </tr>
    <% } } %>
  </tbody>
</table>

</body>
</html>
