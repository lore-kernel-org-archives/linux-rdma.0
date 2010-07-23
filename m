From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/6] librdmacm/man: fix various typos in man pages
Date: Thu, 22 Jul 2010 21:17:31 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A732D5FD@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A732D5F4@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A732D5F4-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 man/rdma_cm.7          |   49 +++++++++++++++++++++++++++++-------------------
 man/rdma_connect.3     |    5 +++--
 man/rdma_create_ep.3   |    4 ++--
 man/rdma_create_id.3   |    4 ++--
 man/rdma_destroy_id.3  |    4 ++--
 man/rdma_getaddrinfo.3 |    8 ++++----
 6 files changed, 43 insertions(+), 31 deletions(-)

diff --git a/man/rdma_cm.7 b/man/rdma_cm.7
index 8dd0649..ee8427a 100644
--- a/man/rdma_cm.7
+++ b/man/rdma_cm.7
@@ -1,4 +1,4 @@
-.TH "RDMA_CM" 7 "2008-01-02" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.TH "RDMA_CM" 7 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_cm \- RDMA communication manager.
 .SH SYNOPSIS
@@ -9,7 +9,7 @@ Used to establish communication over RDMA transports.
 The RDMA CM is a communication manager used to setup reliable, connected
 and unreliable datagram data transfers.  It provides an RDMA transport
 neutral interface for establishing connections.  The API concepts are
-is based on sockets, but adapted for queue pair (QP) based semantics:
+based on sockets, but adapted for queue pair (QP) based semantics:
 communication must be over a specific RDMA device, and data transfers
 are message based.
 .P
@@ -24,31 +24,42 @@ operation is controlled by the user through the use of the rdma_cm event channel
 parameter in specific calls.  If an event channel is provided, an rdma_cm identifier
 will report its event data (results of connecting, for example), on that channel.
 If a channel is not provided, then all rdma_cm operations for the selected
-rdma_cm identifier are will block until they complete.
+rdma_cm identifier will block until they complete.
 .SH "RDMA VERBS"
 The rdma_cm supports the full range of verbs available through the libibverbs
 library and interfaces.  However, it also provides wrapper functions for some
 of the more commonly used verbs funcationality.  The full set of abstracted
 verb calls are:
-.P rdma_reg_msgs  - register an array of buffers for sending and receiving
-.P rdma_reg_read  - registers a buffer for RDMA read operations
-.P rdma_reg_write - registers a buffer for RDMA write operations
-.P rdma_dereg_mr  - deregisters a memory region
 .P
-.P rdma_post_recv  - post a buffer to receive a message
-.P rdma_post_send  - post a buffer to send a message
-.P rdma_post_read  - post an RDMA to read data into a buffer
-.P rdma_post_write - post an RDMA to send data from a buffer
+rdma_reg_msgs  - register an array of buffers for sending and receiving
 .P
-.P rdma_post_recvv  - post a vector of buffers to receive a message
-.P rdma_post_sendv  - post a vector of buffers to send a message
-.P rdma_post_readv  - post a vector of buffers to receive an RDMA read
-.P rdma_post_writev - post a vector of buffers to send an RDMA write
+rdma_reg_read  - registers a buffer for RDMA read operations
 .P
-.P rdma_post_ud_send - post a buffer to send a message on a UD QP
+rdma_reg_write - registers a buffer for RDMA write operations
 .P
-.P rdma_get_send_comp - get completion status for a send or RDMA operation
-.P rdma_get_recv_comp - get information about a completed receive
+rdma_dereg_mr  - deregisters a memory region
+.P
+rdma_post_recv  - post a buffer to receive a message
+.P
+rdma_post_send  - post a buffer to send a message
+.P
+rdma_post_read  - post an RDMA to read data into a buffer
+.P
+rdma_post_write - post an RDMA to send data from a buffer
+.P
+rdma_post_recvv  - post a vector of buffers to receive a message
+.P
+rdma_post_sendv  - post a vector of buffers to send a message
+.P
+rdma_post_readv  - post a vector of buffers to receive an RDMA read
+.P
+rdma_post_writev - post a vector of buffers to send an RDMA write
+.P
+rdma_post_ud_send - post a buffer to send a message on a UD QP
+.P
+rdma_get_send_comp - get completion status for a send or RDMA operation
+.P
+rdma_get_recv_comp - get information about a completed receive
 .SH "CLIENT OPERATION"
 This section provides a general overview of the basic operation for the active,
 or client, side of communication.  This flow assume asynchronous operation with
@@ -151,7 +162,7 @@ success
 .IP "= -1"
 error - see errno for more details
 .P
-Librdmacm functions return 0 to indicate success, and a -1 return value
+Most librdmacm functions return 0 to indicate success, and a -1 return value
 to indicate failure.  If a function operates asynchronously, a return value of 0
 means that the operation was successfully started.  The operation could still
 complete in error; users should check the status of the related event.  If the
diff --git a/man/rdma_connect.3 b/man/rdma_connect.3
index 278375a..b0cc51e 100644
--- a/man/rdma_connect.3
+++ b/man/rdma_connect.3
@@ -1,4 +1,4 @@
-.TH "RDMA_CONNECT" 3 "2007-10-31" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.TH "RDMA_CONNECT" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_connect \- Initiate an active connection request.
 .SH SYNOPSIS
@@ -21,7 +21,8 @@ Returns 0 on success, or -1 on error.  If an error occurs, errno will be
 set to indicate the failure reason.
 .SH "NOTES"
 Users must have resolved a route to the destination address
-by having called rdma_resolve_route before calling this routine.
+by having called rdma_resolve_route or rdma_create_ep before calling
+this routine.
 .SH "CONNECTION PROPERTIES"
 The following properties are used to configure the communication and specified
 by the conn_param parameter when connecting or establishing datagram
diff --git a/man/rdma_create_ep.3 b/man/rdma_create_ep.3
index 26cf177..cb9b8b6 100644
--- a/man/rdma_create_ep.3
+++ b/man/rdma_create_ep.3
@@ -1,4 +1,4 @@
-.TH "RDMA_CREATE_EP" 3 "2007-08-06" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.TH "RDMA_CREATE_EP" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_create_ep \- Allocate a communication identifier and optional QP.
 .SH SYNOPSIS
@@ -30,7 +30,7 @@ After resolving address information using rdma_getaddrinfo, a user
 may use this call to allocate an rdma_cm_id based on the results.
 .P
 If the rdma_cm_id will be used on the active side of a connection,
-meaning that res->ai_flag is not RAI_PASSIVE set, rdma_create_ep
+meaning that res->ai_flag does not have RAI_PASSIVE set, rdma_create_ep
 will automatically create a QP on the rdma_cm_id if qp_init_attr is
 not NULL.  The QP will be associated with the specified protection
 domain, if provided, or a default protection domain if not.  Users
diff --git a/man/rdma_create_id.3 b/man/rdma_create_id.3
index 4fa18b2..da333fb 100644
--- a/man/rdma_create_id.3
+++ b/man/rdma_create_id.3
@@ -1,4 +1,4 @@
-.TH "RDMA_CREATE_ID" 3 "2007-08-06" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.TH "RDMA_CREATE_ID" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_create_id \- Allocate a communication identifier.
 .SH SYNOPSIS
@@ -31,7 +31,7 @@ communication.  The difference is that RDMA communication requires
 explicitly binding to a specified RDMA device before communication
 can occur, and most operations are asynchronous in nature.  Asynchronous
 communication events on an rdma_cm_id are reported through the associated
-event channel.  If the channel paramet is NULL, the rdma_cm_id will
+event channel.  If the channel parameter is NULL, the rdma_cm_id will
 be placed into synchronous operation.  While operating synchronously,
 calls that result in an event will block until the operation completes.
 The event will be returned to the user through the rdma_cm_id structure,
diff --git a/man/rdma_destroy_id.3 b/man/rdma_destroy_id.3
index c66af8e..0fef7a8 100644
--- a/man/rdma_destroy_id.3
+++ b/man/rdma_destroy_id.3
@@ -1,4 +1,4 @@
-.TH "RDMA_DESTROY_ID" 3 "2007-05-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.TH "RDMA_DESTROY_ID" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_destroy_id \- Release a communication identifier.
 .SH SYNOPSIS
@@ -17,6 +17,6 @@ Returns 0 on success, or -1 on error.  If an error occurs, errno will be
 set to indicate the failure reason.
 .SH "NOTES"
 Users must free any associated QP with the rdma_cm_id before
-calling this routine and ack an related events.
+calling this routine and ack all related events.
 .SH "SEE ALSO"
 rdma_create_id(3), rdma_destroy_qp(3), rdma_ack_cm_event(3)
diff --git a/man/rdma_getaddrinfo.3 b/man/rdma_getaddrinfo.3
index e49cf52..c418b5a 100644
--- a/man/rdma_getaddrinfo.3
+++ b/man/rdma_getaddrinfo.3
@@ -1,4 +1,4 @@
-.TH "RDMA_GETADDRINFO" 3 "2007-10-31" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.TH "RDMA_GETADDRINFO" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_getaddrinfo \- Provides transport independent address translation.
 .SH SYNOPSIS
@@ -35,8 +35,8 @@ passive side of a connection.
 .SH "rdma_addrinfo"
 .IP "ai_flags" 12
 Hint flags that control the operation.  Supported flags are:
-.P
-RAI_PASSIVE - indicates that the results will be used on the passive/listening
+.IP "RAI_PASSIVE" 12
+Indicates that the results will be used on the passive/listening
 side of a connection.
 .IP "ai_family" 12
 Address family for the source and destination address.  Supported families
@@ -69,7 +69,7 @@ could be resolved.
 Routing information for RDMA transports that require routing data as part
 of connection establishment.  The format of the routing data depends on
 the underlying transport.  If Infiniband transports are
-used, ai_route will reference an array of struct ib_path_data.
+used, ai_route will reference an array of struct ibv_path_data.
 .IP "ai_connect_len" 12
 Size of connection information referenced by ai_connect.  This will be
 0 if the underlying transport does not require additional connection


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
