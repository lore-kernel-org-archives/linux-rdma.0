From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 34/37] librdmacm: update man pages
Date: Wed, 7 Apr 2010 10:12:43 -0700
Message-ID: <4080563C8473436DB118953312C0320C@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Update man pages to reflect changes to the APIs.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 man/rdma_cm.7          |   56 +++++++++++++++++++++++++++++++++++++++++------
 man/rdma_create_ep.3   |   57 ++++++++++++++++++++++++++++++++++++++++++++++++
 man/rdma_create_id.3   |   14 ++++++++----
 man/rdma_create_qp.3   |   15 +++++++++++--
 man/rdma_get_request.3 |   31 ++++++++++++++++++++++++++
 man/rdma_migrate_id.3  |    6 ++++-
 6 files changed, 165 insertions(+), 14 deletions(-)

diff --git a/man/rdma_cm.7 b/man/rdma_cm.7
index fd04959..ff5d489 100644
--- a/man/rdma_cm.7
+++ b/man/rdma_cm.7
@@ -8,17 +8,59 @@ Used to establish communication over RDMA transports.
 .SH "NOTES"
 The RDMA CM is a communication manager used to setup reliable, connected
 and unreliable datagram data transfers.  It provides an RDMA transport
-neutral interface for establishing connections.  The API is based on sockets,
-but adapted for queue pair (QP) based semantics: communication must be
-over a specific RDMA device, and data transfers are message based.
+neutral interface for establishing connections.  The API concepts are
+is based on sockets, but adapted for queue pair (QP) based semantics:
+communication must be over a specific RDMA device, and data transfers
+are message based.
 .P
-The RDMA CM only provides the communication management (connection setup /
-teardown) portion of an RDMA API.  It works in conjunction with the verbs
+The RDMA CM can control both the QP and communication management (connection setup /
+teardown) portions of an RDMA API, or only the communication management
+piece.  It works in conjunction with the verbs
 API defined by the libibverbs library.  The libibverbs library provides the
-interfaces needed to send and receive data.
+underlying interfaces needed to send and receive data.
+.P
+The RDMA CM can operate asynchronously or synchronously.  The mode of
+operation is controlled by the user through the use of the rdma_cm event channel
+parameter in specific calls.  If an event channel is provided, an rdma_cm identifier
+will report its event data (results of connecting, for example), on that channel.
+If a channel is not provided, then all rdma_cm operations for the selected
+rdma_cm identifier are will block until they complete.
+.SH "RDMA VERBS"
+The rdma_cm supports the full range of verbs available through the libibverbs
+library and interfaces.  However, it also provides wrapper functions for some
+of the more commonly used verbs funcationality.  The full set of abstracted
+verb calls are:
+.P rdma_reg_msgs  - register an array of buffers for sending and receiving
+.P rdma_reg_read  - registers a buffer for RDMA read operations
+.P rdma_reg_write - registers a buffer for RDMA write operations
+.P rdma_dereg_mr  - deregisters a memory region
+.P
+.P rdma_post_recv  - post a buffer to receive a message
+.P rdma_post_send  - post a buffer to send a message
+.P rdma_post_read  - post an RDMA to read data into a buffer
+.P rdma_post_write - post an RDMA to send data from a buffer
+.P
+.P rdma_post_recvv  - post a vector of buffers to receive a message
+.P rdma_post_sendv  - post a vector of buffers to send a message
+.P rdma_post_readv  - post a vector of buffers to receive an RDMA read
+.P rdma_post_writev - post a vector of buffers to send an RDMA write
+.P
+.P rdma_post_ud_send - post a buffer to send a message on a UD QP
+.P
+.P rdma_get_send_comp - get completion status for a send or RDMA operation
+.P rdma_get_recv_comp - get information about a completed receive
 .SH "CLIENT OPERATION"
 This section provides a general overview of the basic operation for the active,
-or client, side of communication.  A general connection flow would be:
+or client, side of communication.  This flow assume asynchronous operation with
+low level call details shown.  For
+synchronous operation, calls to rdma_create_event_channel, rdma_get_cm_event,
+rdma_ack_cm_event, and rdma_destroy_event_channel
+would be eliminated.  Abstracted calls, such as rdma_create_ep encapsulate
+serveral of these calls under a single API.
+Users may also refer to the example applications for
+code samples.  A general connection flow would be:
+.IP rdma_getaddrinfo
+retrieve address information of the destination
 .IP rdma_create_event_channel
 create channel to receive events
 .IP rdma_create_id
diff --git a/man/rdma_create_ep.3 b/man/rdma_create_ep.3
new file mode 100644
index 0000000..ae07113
--- /dev/null
+++ b/man/rdma_create_ep.3
@@ -0,0 +1,57 @@
+.TH "RDMA_CREATE_EP" 3 "2007-08-06" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.SH NAME
+rdma_create_ep \- Allocate a communication identifier and optional QP.
+.SH SYNOPSIS
+.B "#include <rdma/rdma_cma.h>"
+.P
+.B "int" rdma_create_ep
+.BI "(struct rdma_cm_id **" id ","
+.BI "struct rdma_addrinfo *" res ","
+.BI "struct ibv_pd  *" pd ","
+.BI "struct ibv_qp_init_attr *" qp_init_attr ");"
+.SH ARGUMENTS
+.IP "id" 12
+A reference where the allocated communication identifier will be
+returned.
+.IP "res" 12
+Address information associated with the rdma_cm_id returned from
+rdma_getaddrinfo.
+.IP "pd" 12
+Optional protection domain if a QP is associated with the rdma_cm_id.
+.IP "qp_init_attr" 12
+Optional initial QP attributes.
+.SH "DESCRIPTION"
+Creates an identifier that is used to track communication information.
+.SH "NOTES"
+After resolving address information using rdma_getaddrinfo, a user
+may use this call to allocate an rdma_cm_id based on the results.
+.P
+If the rdma_cm_id will be used on the active side of a connection,
+meaning that res->ai_flag is not RAI_PASSIVE set, rdma_create_ep
+will automatically create a QP on the rdma_cm_id if qp_init_attr is
+not NULL.  The QP will be associated with the specified protection
+domain, if provided, or a default protection domain if not.  Users
+should see rdma_create_qp for details on the use of the pd and
+qp_init_attr parameters.  After calling rdma_create_ep, the returned
+rdma_cm_id may be connected by calling rdma_connect.  The active side
+calls rdma_resolve_addr and rdma_resolve_route are not necessary.
+.P
+If the rdma_cm_id will be used on the passive side of a connection,
+indicated by having res->ai_flag RAI_PASSIVE set, this call will save
+the provided pd and qp_init_attr parameters.  When a new connection
+request is retrieved by calling rdma_get_request, the rdma_cm_id
+associated with the new connection will automatically be associated
+with a QP using the pd and qp_init_attr parameters.  After calling
+rdma_create_ep, the returned rdma_cm_id may be placed into a listening
+state by immediately calling rdma_listen.  The passive side call
+rdma_bind_addr is not necessary.  Connection requests may then be
+retrieved by calling rdma_get_request.
+.P
+The newly created rdma_cm_id will be set to use synchronous operation.
+Users that wish asynchronous operation must migrate the rdma_cm_id
+to a user created event channel using rdma_migrate_id.
+.P
+Users must release the created rdma_cm_id by calling rdma_destroy_ep.
+.SH "SEE ALSO"
+rdma_cm(7), rdma_getaddrinfo(3), rdma_create_event_channel(3),
+rdma_connect(3), rdma_listen(3), rdma_destroy_ep(3), rdma_migrate_id(3)
diff --git a/man/rdma_create_id.3 b/man/rdma_create_id.3
index eb29f3c..a7926d4 100644
--- a/man/rdma_create_id.3
+++ b/man/rdma_create_id.3
@@ -12,7 +12,7 @@ rdma_create_id \- Allocate a communication identifier.
 .SH ARGUMENTS
 .IP "channel" 12
 The communication channel that events associated with the
-allocated rdma_cm_id will be reported on.
+allocated rdma_cm_id will be reported on.  This may be NULL.
 .IP "id" 12
 A reference where the allocated communication identifier will be
 returned.
@@ -26,9 +26,15 @@ Creates an identifier that is used to track communication information.
 Rdma_cm_id's are conceptually equivalent to a socket for RDMA
 communication.  The difference is that RDMA communication requires
 explicitly binding to a specified RDMA device before communication
-can occur, and most operations are asynchronous in nature.  Communication
-events on an rdma_cm_id are reported through the associated event
-channel.  Users must release the rdma_cm_id by calling rdma_destroy_id.
+can occur, and most operations are asynchronous in nature.  Asynchronous
+communication events on an rdma_cm_id are reported through the associated
+event channel.  If the channel paramet is NULL, the rdma_cm_id will
+be placed into synchronous operation.  While operating synchronously,
+calls that result in an event will block until the operation completes.
+The event will be returned to the user through the rdma_cm_id structure,
+and be available for access until another rdma_cm call is made.
+.P
+Users must release the rdma_cm_id by calling rdma_destroy_id.
 .SH "PORT SPACE"
 Details of the services provided by the different port spaces are outlined
 below.
diff --git a/man/rdma_create_qp.3 b/man/rdma_create_qp.3
index 0931499..ce1d862 100644
--- a/man/rdma_create_qp.3
+++ b/man/rdma_create_qp.3
@@ -12,9 +12,9 @@ rdma_create_qp \- Allocate a QP.
 .IP "id" 12
 RDMA identifier.
 .IP "pd" 12
-protection domain for the QP.
+Optional protection domain for the QP.
 .IP "qp_init_attr" 12
-initial QP attributes.
+Initial QP attributes.
 .SH "DESCRIPTION"
 Allocate a QP associated with the specified rdma_cm_id and transition it
 for sending and receiving.
@@ -25,6 +25,17 @@ QPs allocated to an rdma_cm_id are automatically transitioned by the
 librdmacm through their states.  After being allocated, the QP will be
 ready to handle posting of receives.  If the QP is unconnected, it will
 be ready to post sends.
+.P
+If a protection domain is not given - pd parameter is NULL - then
+the rdma_cm_id will be created using a default protection domain.  One
+default protection domain is allocated per RDMA device.
+.P
+The initial QP attributes are specified by the qp_init_attr parameter.  The
+send_cq and recv_cq fields in the ibv_qp_init_attr are optional.  If
+a send or receive completion queue is not specified, then a CQ will be
+allocated by the rdma_cm for the QP, along with corresponding completion
+channels.  Completion channels and CQ data created by the rdma_cm are
+exposed to the user through the rdma_cm_id structure.
 .SH "SEE ALSO"
 rdma_bind_addr(3), rdma_resolve_addr(3), rdma_destroy_qp(3), ibv_create_qp(3),
 ibv_modify_qp(3)
diff --git a/man/rdma_get_request.3 b/man/rdma_get_request.3
new file mode 100644
index 0000000..cd48918
--- /dev/null
+++ b/man/rdma_get_request.3
@@ -0,0 +1,31 @@
+.TH "RDMA_GET_REQUEST" 3 "2007-10-31" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.SH NAME
+rdma_get_request \- Retrieves the next pending connection request event.
+.SH SYNOPSIS
+.B "#include <rdma/rdma_cma.h>"
+.P
+.B "int" rdma_get_request
+.BI "(struct rdma_cm_id *" listen ","
+.BI "struct rdma_cm_id **" id ");"
+.SH ARGUMENTS
+.IP "listen" 12
+Listening rdma_cm_id.
+.IP "id" 12
+rdma_cm_id associated with the new connection.
+.SH "DESCRIPTION"
+Retrieves a connection request event.  If no requests are pending,
+the call will block until an event is received.
+.SH "NOTES"
+This call may only be used on listening rdma_cm_id's operating
+synchronously.  On success, a new rdma_cm_id representing the
+connection request will be returned to the user.  The new rdma_cm_id
+will reference event information associated with the request until
+the user calls rdma_reject, rdma_accept, or rdma_destroy_id on the
+newly created identifier.  For a description of the event data,
+see rdma_get_cm_event.
+.P
+If QP attributes are associated with the listening endpoint, the
+returned rdma_cm_id will also reference an allocated QP.
+.SH "SEE ALSO"
+rdma_get_cm_event(3), rdma_accept(3), rdma_reject(3),
+rdma_connect(3), rdma_listen(3), rdma_destroy_id(3)
diff --git a/man/rdma_migrate_id.3 b/man/rdma_migrate_id.3
index ffbad45..64448f6 100644
--- a/man/rdma_migrate_id.3
+++ b/man/rdma_migrate_id.3
@@ -12,7 +12,7 @@ rdma_migrate_id \- Move a communication identifer to a different event channel.
 An existing communication identifier to migrate.
 .IP "channel" 12
 The communication channel that events associated with the
-allocated rdma_cm_id will be reported on.
+allocated rdma_cm_id will be reported on.  May be NULL.
 .SH "DESCRIPTION"
 Migrates a communication identifier to a different event channel.
 .SH "NOTES"
@@ -22,6 +22,10 @@ to the new channel.  Users should not poll for events on the
 rdma_cm_id's current event channel or invoke other routines on the
 rdma_cm_id while migrating between channels.  This call will block while
 there are any unacknowledged events on the current event channel.
+.P
+If the channel parameter is NULL, the specified rdma_cm_id will be
+placed into synchronous operation mode.  All calls on the id
+will block until the operation completes.
 .SH "SEE ALSO"
 rdma_cm(7), rdma_create_event_channel(3), rdma_create_id(3),
 rdma_get_cm_event(3)



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
