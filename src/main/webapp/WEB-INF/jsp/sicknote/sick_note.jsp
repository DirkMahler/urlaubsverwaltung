<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="joda" uri="http://www.joda.org/joda/time/tags" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@taglib prefix="uv" tagdir="/WEB-INF/tags" %>

<html>
<head>
    <uv:head />
</head>
<body>

<spring:url var="formUrlPrefix" value="/web"/>

<uv:menu />

<div class="content">

    <div class="container">

        <div class="row">

            <div class="col-xs-12 col-sm-6">

                <div class="header">
                    <legend>
                        <p><spring:message code="sicknote" /></p>
                        <sec:authorize access="hasRole('OFFICE')">
                            <c:if test="${sickNote.active}">
                                <div class="btn-group pull-right">
                                    <a class="btn btn-default dropdown-toggle" data-toggle="dropdown" href="#">
                                        <%--<i class="fa fa-chevron-down"></i>--%>
                                        <i class="fa fa-edit"></i>
                                        <spring:message code="action" />
                                        <span class="caret"></span>
                                    </a>
                                    <ul class="dropdown-menu">
                                        <li>
                                            <a href="#" media="print" onclick="window.print(); return false;">
                                                <i class="fa fa-print"></i>&nbsp;&nbsp;<spring:message code='print' />
                                            </a>
                                        </li>
                                        <li>
                                            <a href="${formUrlPrefix}/sicknote/${sickNote.id}/edit">
                                                <i class="fa fa-pencil"></i>&nbsp;&nbsp;<spring:message code="edit" />
                                            </a>
                                        </li>
                                        <li>
                                            <a href="${formUrlPrefix}/sicknote/${sickNote.id}/convert">
                                                <i class="fa fa-retweet"></i>&nbsp;&nbsp;<spring:message code="sicknotes.convert.vacation.short" />
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#modal-cancel" role="button" data-toggle="modal">
                                                <i class="fa fa-trash"></i>&nbsp;&nbsp;<spring:message code="delete" />
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </c:if>
                        </sec:authorize>
                    </legend>
                </div>

                <form:form method="POST" action="${formUrlPrefix}/sicknote/${sickNote.id}/cancel">
                <div id="modal-cancel" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                                <h4 id="myModalLabel" class="modal-title"><spring:message code="sicknote" />&nbsp;<spring:message code="delete" />?</h4>
                            </div>
                            <div class="modal-body">
                                <spring:message code="sicknote.cancel" />
                            </div>
                            <div class="modal-footer">
                                <button class="btn btn-danger" type="submit"><i class="fa fa-trash"></i>&nbsp;<spring:message code="delete" /></button>
                                <button class="btn btn-default" data-dismiss="modal" aria-hidden="true"><i class="fa fa-remove"></i>&nbsp;<spring:message code="cancel" /></button>
                            </div>
                        </div>
                        </div>
                    </div>
                </form:form>
                
              <table class="detail-table">
                  <tbody>
                      <tr class="odd">
                          <td><spring:message code="name" /></td>
                          <td><c:out value="${sickNote.person.firstName}" />&nbsp;<c:out value="${sickNote.person.lastName}" /></td>
                      </tr>
                      <tr class="even">
                          <td><spring:message code="sicknotes.time" /></td>
                          <td>
                              <uv:date date="${sickNote.startDate}" /> - <uv:date date="${sickNote.endDate}" />
                          </td>
                      </tr>
                      <tr class="odd">
                          <td><spring:message code="work.days" /></td>
                          <td><fmt:formatNumber maxFractionDigits="1" value="${sickNote.workDays}" /></td>
                      </tr>
                      <tr class="even">
                          <td><spring:message code="sicknotes.aub" /></td>
                          <td>
                              <c:choose>
                                  <c:when test="${sickNote.aubPresent}">
                                    <i class="fa fa-check"></i>
                                  </c:when>
                                  <c:otherwise>
                                    <i class="fa fa-remove"></i>
                                  </c:otherwise>
                              </c:choose>
                          </td>
                      </tr>
                      <tr class="odd">
                          <td><spring:message code="sicknotes.aub.time" /></td>
                          <td>
                              <uv:date date="${sickNote.aubStartDate}" /> - <uv:date date="${sickNote.aubEndDate}" />
                          </td>
                      </tr>
                      <tr class="even">
                          <td><spring:message code="app.date.overview" /></td>
                          <td><uv:date date="${sickNote.lastEdited}" /></td>
                      </tr>
                  </tbody>
              </table>  
            </div>

            <div class="col-xs-12 col-sm-6">

                <div class="header">
                    <legend>
                        <p><spring:message code="progress" /></p>
                        <sec:authorize access="hasRole('OFFICE')">
                            <button class="btn btn-default pull-right" onclick="$('div#comment-form').show();">
                                <i class="fa fa-comment"></i>&nbsp;Neuer Kommentar
                            </button>
                        </sec:authorize>
                    </legend>
                </div>
                
                <table class="detail-table">
                    <tbody>
                        <c:forEach items="${sickNote.comments}" var="comment" varStatus="loopStatus">
                            <tr class="${loopStatus.index % 2 == 0 ? 'odd' : 'even'}">
                                <td style="width:10%"><uv:date date="${comment.date}" /></td>
                                <td style="width:10%">
                                    <c:out value="${comment.person.firstName}" />&nbsp;<c:out value="${comment.person.lastName}" />
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty comment.text}">
                                            <spring:message code="${comment.status.messageKey}" /> 
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${comment.text}" />
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <sec:authorize access="hasRole('OFFICE')">
                
                    <c:choose>
                        <c:when test="${error}">
                           <c:set var="STYLE" value="display: block" /> 
                        </c:when>
                        <c:otherwise>
                            <c:set var="STYLE" value="display: none" /> 
                        </c:otherwise>
                    </c:choose>
                    
                    <div id="comment-form" style="${STYLE}">
                        <form:form method="POST" action="${formUrlPrefix}/sicknote/${sickNote.id}" modelAttribute="comment">
                            <form:errors path="text" cssClass="error" /><br />
                            <span id="text-comment"></span><spring:message code="max.chars" />
                            <form:textarea rows="4" path="text" cssClass="form-control" cssErrorClass="form-control error" onkeyup="count(this.value, 'text-comment');" onkeydown="maxChars(this,200); count(this.value, 'text-comment');" />
                            <br />
                            <button class="btn btn-default" type="submit">
                                <i class="fa fa-check"></i>&nbsp;<spring:message code="save" />
                            </button>
                            <button class="btn btn-default" type="button" onclick="$('div#comment-form').hide();">
                                <i class="fa fa-remove"></i>&nbsp;<spring:message code="cancel" />
                            </button>
                        </form:form> 
                    </div>
                
                </sec:authorize>
                
            </div>

        </div>

    </div>

</div>

</body>
</html>