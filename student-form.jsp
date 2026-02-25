<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.myapp.Student" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Student Form</title>
  <style>
    body       { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
    .card      { background:#fff; padding:30px 36px; max-width:480px;
                 border-radius:6px; box-shadow:0 2px 6px rgba(0,0,0,.15); }
    h2         { margin-top:0; color:#333; }
    label      { display:block; margin:14px 0 4px; font-weight:bold; color:#555; }
    input[type=text], input[type=email] {
                 width:100%; padding:8px 10px; box-sizing:border-box;
                 border:1px solid #ccc; border-radius:4px; font-size:14px; }
    input:focus{ border-color:#4CAF50; outline:none; }
    .actions   { margin-top:22px; }
    button     { padding:8px 20px; background:#4CAF50; color:#fff;
                 border:none; border-radius:4px; font-size:14px; cursor:pointer; }
    button:hover { background:#45a049; }
    a.cancel   { margin-left:14px; color:#888; text-decoration:none; font-size:14px; }
  </style>
</head>
<body>
<div class="card">

<%
  Student student = (Student) request.getAttribute("student");
  boolean isEdit  = (student != null);
  String  action  = isEdit ? "update" : "insert";
  String  heading = isEdit ? "Edit Student" : "Add New Student";
%>

<h2><%= heading %></h2>

<form action="students" method="post">
  <input type="hidden" name="action" value="<%= action %>">

  <% if (isEdit) { %>
    <input type="hidden" name="id" value="<%= student.getId() %>">
  <% } %>

  <label for="name">Full Name</label>
  <input type="text" id="name" name="name" required
         value="<%= isEdit ? student.getName() : "" %>">

  <label for="email">Email</label>
  <input type="email" id="email" name="email" required
         value="<%= isEdit ? student.getEmail() : "" %>">

  <label for="course">Course</label>
  <input type="text" id="course" name="course" required
         value="<%= isEdit ? student.getCourse() : "" %>">

  <div class="actions">
    <button type="submit"><%= isEdit ? "Update" : "Save" %></button>
    <a class="cancel" href="students?action=list">Cancel</a>
  </div>
</form>

</div>
</body>
</html>
