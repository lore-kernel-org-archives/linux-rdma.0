From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/6] librdmacm: specify return value in man pages
Date: Thu, 22 Jul 2010 21:13:19 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A732D5F7@orsmsx501.amr.corp.intel.com>
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

Document the return value of all calls in their respective man pages.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 man/rdma_accept.3                |    3 +++
 man/rdma_ack_cm_event.3          |    3 +++
 man/rdma_bind_addr.3             |    3 +++
 man/rdma_connect.3               |    3 +++
 man/rdma_create_ep.3             |    3 +++
 man/rdma_create_event_channel.3  |    3 +++
 man/rdma_create_id.3             |    3 +++
 man/rdma_create_qp.3             |    3 +++
 man/rdma_dereg_mr.3              |    3 +++
 man/rdma_destroy_ep.3            |    3 +++
 man/rdma_destroy_event_channel.3 |    3 +++
 man/rdma_destroy_id.3            |    3 +++
 man/rdma_destroy_qp.3            |    3 +++
 man/rdma_disconnect.3            |    3 +++
 man/rdma_event_str.3             |    2 ++
 man/rdma_free_devices.3          |    2 ++
 man/rdma_get_cm_event.3          |    3 +++
 man/rdma_get_devices.3           |    3 +++
 man/rdma_get_dst_port.3          |    3 +++
 man/rdma_get_local_addr.3        |    4 ++++
 man/rdma_get_peer_addr.3         |    4 ++++
 man/rdma_get_recv_comp.3         |    3 +++
 man/rdma_get_request.3           |    3 +++
 man/rdma_get_send_comp.3         |    3 +++
 man/rdma_get_src_port.3          |    3 +++
 man/rdma_getaddrinfo.3           |    3 +++
 man/rdma_join_multicast.3        |    3 +++
 man/rdma_leave_multicast.3       |    3 +++
 man/rdma_listen.3                |    3 +++
 man/rdma_migrate_id.3            |    3 +++
 man/rdma_notify.3                |    3 +++
 man/rdma_post_read.3             |    3 +++
 man/rdma_post_readv.3            |    3 +++
 man/rdma_post_recv.3             |    3 +++
 man/rdma_post_recvv.3            |    3 +++
 man/rdma_post_send.3             |    3 +++
 man/rdma_post_sendv.3            |    3 +++
 man/rdma_post_ud_send.3          |    3 +++
 man/rdma_post_write.3            |    3 +++
 man/rdma_post_writev.3           |    3 +++
 man/rdma_reg_msgs.3              |    3 +++
 man/rdma_reg_read.3              |    3 +++
 man/rdma_reg_write.3             |    3 +++
 man/rdma_reject.3                |    3 +++
 man/rdma_resolve_addr.3          |    3 +++
 man/rdma_resolve_route.3         |    3 +++
 man/rdma_set_option.3            |    3 +++
 47 files changed, 141 insertions(+), 0 deletions(-)

diff --git a/man/rdma_accept.3 b/man/rdma_accept.3
index bdf90bd..ac04e2c 100644
--- a/man/rdma_accept.3
+++ b/man/rdma_accept.3
@@ -16,6 +16,9 @@ below for details.
 .SH "DESCRIPTION"
 Called from the listening side to accept a connection or datagram
 service lookup request.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 Unlike the socket accept routine, rdma_accept is not called on a
 listening rdma_cm_id.  Instead, after calling rdma_listen, the user
diff --git a/man/rdma_ack_cm_event.3 b/man/rdma_ack_cm_event.3
index 3c24357..bcf20f7 100644
--- a/man/rdma_ack_cm_event.3
+++ b/man/rdma_ack_cm_event.3
@@ -14,5 +14,8 @@ All events which are allocated by rdma_get_cm_event must be released,
 there should be a one-to-one correspondence between successful gets
 and acks.  This call frees the event structure and any memory that it
 references.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "SEE ALSO"
 rdma_get_cm_event(3), rdma_destroy_id(3)
diff --git a/man/rdma_bind_addr.3 b/man/rdma_bind_addr.3
index 06f30ce..8f9bc60 100644
--- a/man/rdma_bind_addr.3
+++ b/man/rdma_bind_addr.3
@@ -16,6 +16,9 @@ Local address information.  Wildcard values are permitted.
 Associates a source address with an rdma_cm_id.  The address may be
 wildcarded.  If binding to a specific local address, the rdma_cm_id
 will also be bound to a local RDMA device.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 Typically, this routine is called before calling rdma_listen to bind
 to a specific port number, but it may also be called on the active side
diff --git a/man/rdma_connect.3 b/man/rdma_connect.3
index 8dab9ee..278375a 100644
--- a/man/rdma_connect.3
+++ b/man/rdma_connect.3
@@ -16,6 +16,9 @@ connection parameters.  See CONNECTION PROPERTIES below for details.
 For an rdma_cm_id of type RDMA_PS_TCP, this call initiates a connection request
 to a remote destination.  For an rdma_cm_id of type RDMA_PS_UDP, it initiates
 a lookup of the remote QP providing the datagram service.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 Users must have resolved a route to the destination address
 by having called rdma_resolve_route before calling this routine.
diff --git a/man/rdma_create_ep.3 b/man/rdma_create_ep.3
index ae07113..26cf177 100644
--- a/man/rdma_create_ep.3
+++ b/man/rdma_create_ep.3
@@ -22,6 +22,9 @@ Optional protection domain if a QP is associated with the rdma_cm_id.
 Optional initial QP attributes.
 .SH "DESCRIPTION"
 Creates an identifier that is used to track communication information.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 After resolving address information using rdma_getaddrinfo, a user
 may use this call to allocate an rdma_cm_id based on the results.
diff --git a/man/rdma_create_event_channel.3 b/man/rdma_create_event_channel.3
index 67db268..baa48a6 100644
--- a/man/rdma_create_event_channel.3
+++ b/man/rdma_create_event_channel.3
@@ -11,6 +11,9 @@ rdma_create_event_channel \- Open a channel used to report communication events.
 no arguments
 .SH "DESCRIPTION"
 Asynchronous events are reported to users through event channels.
+.SH "RETURN VALUE"
+Returns a pointer to the created event channel, or NULL if the request
+fails.  On failure, errno will be set to indicate the failure reason.
 .SH "NOTES"
 Event channels are used to direct all events on an rdma_cm_id.  For many
 clients, a single event channel may be sufficient, however, when managing
diff --git a/man/rdma_create_id.3 b/man/rdma_create_id.3
index a7926d4..4fa18b2 100644
--- a/man/rdma_create_id.3
+++ b/man/rdma_create_id.3
@@ -22,6 +22,9 @@ User specified context associated with the rdma_cm_id.
 RDMA port space.
 .SH "DESCRIPTION"
 Creates an identifier that is used to track communication information.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 Rdma_cm_id's are conceptually equivalent to a socket for RDMA
 communication.  The difference is that RDMA communication requires
diff --git a/man/rdma_create_qp.3 b/man/rdma_create_qp.3
index ce1d862..9d2de76 100644
--- a/man/rdma_create_qp.3
+++ b/man/rdma_create_qp.3
@@ -18,6 +18,9 @@ Initial QP attributes.
 .SH "DESCRIPTION"
 Allocate a QP associated with the specified rdma_cm_id and transition it
 for sending and receiving.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 The rdma_cm_id must be bound to a local RDMA device before calling this
 function, and the protection domain must be for that same device.
diff --git a/man/rdma_dereg_mr.3 b/man/rdma_dereg_mr.3
index f4d46f1..298e886 100644
--- a/man/rdma_dereg_mr.3
+++ b/man/rdma_dereg_mr.3
@@ -14,6 +14,9 @@ Deregisters a memory buffer that had been registered for RDMA
 or message operations.  A user should call rdma_dereg_mr for all
 registered memory associated with an rdma_cm_id before destroying
 the rdma_cm_id.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 All memory registered with an rdma_cm_id is associated with the
 protection domain associated with the id.  Users must deregister
diff --git a/man/rdma_destroy_ep.3 b/man/rdma_destroy_ep.3
index a88294e..13a8766 100644
--- a/man/rdma_destroy_ep.3
+++ b/man/rdma_destroy_ep.3
@@ -11,6 +11,9 @@ rdma_destroy_ep \- Release a communication identifier.
 The communication identifier to destroy.
 .SH "DESCRIPTION"
 Destroys the specified rdma_cm_id and all associated resources
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 rdma_destroy_ep will automatically destroy any QP associated with
 the rdma_cm_id.
diff --git a/man/rdma_destroy_event_channel.3 b/man/rdma_destroy_event_channel.3
index ed4636e..2c5b8d6 100644
--- a/man/rdma_destroy_event_channel.3
+++ b/man/rdma_destroy_event_channel.3
@@ -12,6 +12,9 @@ The communication channel to destroy.
 .SH "DESCRIPTION"
 Release all resources associated with an event channel and closes the
 associated file descriptor.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 All rdma_cm_id's associated with the event channel must be destroyed,
 and all returned events must be acked before calling this function.
diff --git a/man/rdma_destroy_id.3 b/man/rdma_destroy_id.3
index 77e8151..c66af8e 100644
--- a/man/rdma_destroy_id.3
+++ b/man/rdma_destroy_id.3
@@ -12,6 +12,9 @@ The communication identifier to destroy.
 .SH "DESCRIPTION"
 Destroys the specified rdma_cm_id and cancels any outstanding
 asynchronous operation.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 Users must free any associated QP with the rdma_cm_id before
 calling this routine and ack an related events.
diff --git a/man/rdma_destroy_qp.3 b/man/rdma_destroy_qp.3
index bb1360e..aeff667 100644
--- a/man/rdma_destroy_qp.3
+++ b/man/rdma_destroy_qp.3
@@ -11,6 +11,9 @@ rdma_destroy_qp \- Deallocate a QP.
 RDMA identifier.
 .SH "DESCRIPTION"
 Destroy a QP allocated on the rdma_cm_id.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 Users must destroy any QP associated with an rdma_cm_id before
 destroying the ID.
diff --git a/man/rdma_disconnect.3 b/man/rdma_disconnect.3
index 8b2a035..cd934cb 100644
--- a/man/rdma_disconnect.3
+++ b/man/rdma_disconnect.3
@@ -15,5 +15,8 @@ which will flush any posted work requests to the completion queue.  This
 routine may be called by both the client and server side of a connection.
 After successfully disconnecting, an RDMA_CM_EVENT_DISCONNECTED event will be
 generated on both sides of the connection.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "SEE ALSO"
 rdma_connect(3), rdma_listen(3), rdma_accept(3), rdma_get_cm_event(3)
diff --git a/man/rdma_event_str.3 b/man/rdma_event_str.3
index 6126983..abd016d 100644
--- a/man/rdma_event_str.3
+++ b/man/rdma_event_str.3
@@ -11,5 +11,7 @@ rdma_event_str \- Returns a string representation of an rdma cm event.
 Asynchronous event.
 .SH "DESCRIPTION"
 Returns a string representation of an asynchronous event.
+.SH "RETURN VALUE"
+Returns a pointer to a static character string corresponding to the event.
 .SH "SEE ALSO"
 rdma_get_cm_event(3)
diff --git a/man/rdma_free_devices.3 b/man/rdma_free_devices.3
index 1ed4cb3..37b82ef 100644
--- a/man/rdma_free_devices.3
+++ b/man/rdma_free_devices.3
@@ -11,5 +11,7 @@ rdma_free_devices \- Frees the list of devices returned by rdma_get_devices.
 List of devices returned from rdma_get_devices.
 .SH "DESCRIPTION"
 Frees the device array returned by rdma_get_devices.
+.SH "RETURN VALUE"
+None
 .SH "SEE ALSO"
 rdma_get_devices(3)
diff --git a/man/rdma_get_cm_event.3 b/man/rdma_get_cm_event.3
index 79bf606..2ea1b56 100644
--- a/man/rdma_get_cm_event.3
+++ b/man/rdma_get_cm_event.3
@@ -15,6 +15,9 @@ Allocated information about the next communication event.
 .SH "DESCRIPTION"
 Retrieves a communication event.  If no events are pending, by default,
 the call will block until an event is received.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 The default synchronous behavior of this routine can be changed by
 modifying the file descriptor associated with the given channel.  All
diff --git a/man/rdma_get_devices.3 b/man/rdma_get_devices.3
index 05dcee2..7f42722 100644
--- a/man/rdma_get_devices.3
+++ b/man/rdma_get_devices.3
@@ -13,6 +13,9 @@ If non-NULL, set to the number of devices returned.
 Return a NULL-terminated array of opened RDMA devices.  Callers can use
 this routine to allocate resources on specific RDMA devices that will be
 shared across multiple rdma_cm_id's.
+.SH "RETURN VALUE"
+Returns an array of available RDMA devices, or NULL if the request
+fails.  On failure, errno will be set to indicate the failure reason.
 .SH "NOTES"
 The returned array must be released by calling rdma_free_devices.  Devices
 remain opened while the librdmacm is loaded.
diff --git a/man/rdma_get_dst_port.3 b/man/rdma_get_dst_port.3
index 92932e9..1567749 100644
--- a/man/rdma_get_dst_port.3
+++ b/man/rdma_get_dst_port.3
@@ -12,6 +12,9 @@ RDMA identifier.
 .SH "DESCRIPTION"
 Returns the remote port number for an rdma_cm_id that has been bound to
 a remote address.
+.SH "RETURN VALUE"
+Returns the 16-bit port identifier associated with the peer endpoint.  If
+the rdma_cm_id is not connected, the returned value is 0.
 .SH "SEE ALSO"
 rdma_connect(3), rdma_accept(3), rdma_get_cm_event(3), rdma_get_src_port(3),
 rdma_get_local_addr(3), rdma_get_peer_addr(3)
diff --git a/man/rdma_get_local_addr.3 b/man/rdma_get_local_addr.3
index 8085627..25d5312 100644
--- a/man/rdma_get_local_addr.3
+++ b/man/rdma_get_local_addr.3
@@ -12,6 +12,10 @@ RDMA identifier.
 .SH "DESCRIPTION"
 Returns the local IP address for an rdma_cm_id that has been bound to
 a local device.
+.SH "RETURN VALUE"
+Returns a pointer to the local sockaddr address of the rdma_cm_id.  If
+the rdma_cm_id is not bound to an address, the contents of the sockaddr
+structure will be set to all zeroes.
 .SH "SEE ALSO"
 rdma_bind_addr(3), rdma_resolve_addr(3), rdma_get_src_port(3),
 rdma_get_dst_port(3), rdma_get_peer_addr(3)
diff --git a/man/rdma_get_peer_addr.3 b/man/rdma_get_peer_addr.3
index 880e9c5..54f3139 100644
--- a/man/rdma_get_peer_addr.3
+++ b/man/rdma_get_peer_addr.3
@@ -11,6 +11,10 @@ rdma_get_peer_addr \- Returns the remote IP address of a bound rdma_cm_id.
 RDMA identifier.
 .SH "DESCRIPTION"
 Returns the remote IP address associated with an rdma_cm_id.
+.SH "RETURN VALUE"
+Returns a pointer to the sockaddr address of the connected peer.  If
+the rdma_cm_id is not connected, the contents of the sockaddr
+structure will be set to all zeroes.
 .SH "SEE ALSO"
 rdma_resolve_addr(3), rdma_get_src_port(3), rdma_get_dst_port(3),
 rdma_get_local_addr(3)
diff --git a/man/rdma_get_recv_comp.3 b/man/rdma_get_recv_comp.3
index 349c505..dece89d 100644
--- a/man/rdma_get_recv_comp.3
+++ b/man/rdma_get_recv_comp.3
@@ -17,6 +17,9 @@ Retrieves a completed work request for a receive
 operation.  Information about the completed request is returned through
 the wc parameter, with the wr_id set to the context of the request.  For
 details on the work completion structure, see ibv_poll_cq.
+.SH "RETURN VALUE"
+Returns the number of returned completions (0 or 1) on success, or -1 on error.
+If an error occurs, errno will be set to indicate the failure reason.
 .SH "NOTES"
 This calls polls the receive completion queue associated with an rdma_cm_id.
 If a completion is not found, the call blocks until a request completes.
diff --git a/man/rdma_get_request.3 b/man/rdma_get_request.3
index cd48918..93ec70d 100644
--- a/man/rdma_get_request.3
+++ b/man/rdma_get_request.3
@@ -15,6 +15,9 @@ rdma_cm_id associated with the new connection.
 .SH "DESCRIPTION"
 Retrieves a connection request event.  If no requests are pending,
 the call will block until an event is received.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 This call may only be used on listening rdma_cm_id's operating
 synchronously.  On success, a new rdma_cm_id representing the
diff --git a/man/rdma_get_send_comp.3 b/man/rdma_get_send_comp.3
index 2775b7d..f0c92b4 100644
--- a/man/rdma_get_send_comp.3
+++ b/man/rdma_get_send_comp.3
@@ -17,6 +17,9 @@ Retrieves a completed work request for a send, RDMA read, or RDMA write
 operation.  Information about the completed request is returned through
 the wc parameter, with the wr_id set to the context of the request.  For
 details on the work completion structure, see ibv_poll_cq.
+.SH "RETURN VALUE"
+Returns the number of returned completions (0 or 1) on success, or -1 on error.
+If an error occurs, errno will be set to indicate the failure reason.
 .SH "NOTES"
 This calls polls the send completion queue associated with an rdma_cm_id.
 If a completion is not found, the call blocks until a request completes.
diff --git a/man/rdma_get_src_port.3 b/man/rdma_get_src_port.3
index 0a2f445..477ec73 100644
--- a/man/rdma_get_src_port.3
+++ b/man/rdma_get_src_port.3
@@ -12,6 +12,9 @@ RDMA identifier.
 .SH "DESCRIPTION"
 Returns the local port number for an rdma_cm_id that has been bound to
 a local address.
+.SH "RETURN VALUE"
+Returns the 16-bit port identifier associated with the local endpoint.  If
+the rdma_cm_id is not bound to a port, the returned value is 0.
 .SH "SEE ALSO"
 rdma_bind_addr(3), rdma_resolve_addr(3), rdma_get_dst_port(3),
 rdma_get_local_addr(3), rdma_get_peer_addr(3)
diff --git a/man/rdma_getaddrinfo.3 b/man/rdma_getaddrinfo.3
index 8a1d601..e49cf52 100644
--- a/man/rdma_getaddrinfo.3
+++ b/man/rdma_getaddrinfo.3
@@ -24,6 +24,9 @@ information.
 Resolves the destination node and service address and returns
 information needed to establish communication.  Provides the
 RDMA functional equivalent to getaddrinfo.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 Either node or service must be provided.  If hints are provided, the
 operation will be controlled by hints.ai_flags.  If RAI_PASSIVE is
diff --git a/man/rdma_join_multicast.3 b/man/rdma_join_multicast.3
index 2df57a0..92c2d8d 100644
--- a/man/rdma_join_multicast.3
+++ b/man/rdma_join_multicast.3
@@ -17,6 +17,9 @@ Multicast address identifying the group to join.
 User-defined context associated with the join request.
 .SH "DESCRIPTION"
 Joins a multicast group and attaches an associated QP to the group.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 Before joining a multicast group, the rdma_cm_id must be bound to
 an RDMA device by calling rdma_bind_addr or rdma_resolve_addr.  Use of
diff --git a/man/rdma_leave_multicast.3 b/man/rdma_leave_multicast.3
index e4262e8..802ba57 100644
--- a/man/rdma_leave_multicast.3
+++ b/man/rdma_leave_multicast.3
@@ -14,6 +14,9 @@ Communication identifier associated with the request.
 Multicast address identifying the group to leave.
 .SH "DESCRIPTION"
 Leaves a multicast group and detaches an associated QP from the group.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 Calling this function before a group has been fully joined results in
 canceling the join operation.  Users should be aware that messages
diff --git a/man/rdma_listen.3 b/man/rdma_listen.3
index 4266184..b76d692 100644
--- a/man/rdma_listen.3
+++ b/man/rdma_listen.3
@@ -16,6 +16,9 @@ backlog of incoming connection requests.
 Initiates a listen for incoming connection requests or datagram service
 lookup.  The listen will be restricted to the locally bound source
 address.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 Users must have bound the rdma_cm_id to a local address by calling
 rdma_bind_addr before calling this routine.  If the rdma_cm_id is
diff --git a/man/rdma_migrate_id.3 b/man/rdma_migrate_id.3
index 64448f6..8683c93 100644
--- a/man/rdma_migrate_id.3
+++ b/man/rdma_migrate_id.3
@@ -15,6 +15,9 @@ The communication channel that events associated with the
 allocated rdma_cm_id will be reported on.  May be NULL.
 .SH "DESCRIPTION"
 Migrates a communication identifier to a different event channel.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 This routine migrates a communication identifier to the specified event
 channel and moves any pending events associated with the rdma_cm_id
diff --git a/man/rdma_notify.3 b/man/rdma_notify.3
index 88420c2..a29ee07 100644
--- a/man/rdma_notify.3
+++ b/man/rdma_notify.3
@@ -15,6 +15,9 @@ Asynchronous event.
 .SH "DESCRIPTION"
 Used to notify the librdmacm of asynchronous events that have occurred
 on a QP associated with the rdma_cm_id.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 Asynchronous events that occur on a QP are reported through the user's
 device event handler.  This routine is used to notify the librdmacm of
diff --git a/man/rdma_post_read.3 b/man/rdma_post_read.3
index faf6979..d7afc5b 100644
--- a/man/rdma_post_read.3
+++ b/man/rdma_post_read.3
@@ -35,6 +35,9 @@ The registered memory key associated with the remote address.
 Posts a work request to the send queue of the queue pair associated
 with the rdma_cm_id.  The contents of the remote memory region will be
 read into the local data buffer.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 For a list of supported flags, see ibv_post_send.
 Both the remote and local data buffers must have been registered
diff --git a/man/rdma_post_readv.3 b/man/rdma_post_readv.3
index 185474f..cccf2c3 100644
--- a/man/rdma_post_readv.3
+++ b/man/rdma_post_readv.3
@@ -32,6 +32,9 @@ The registered memory key associated with the remote address.
 Posts a work request to the send queue of the queue pair associated
 with the rdma_cm_id.  The contents of the remote memory region will be
 read into the local data buffers.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 For a list of supported flags, see ibv_post_send.
 Both the remote and local data buffers must have been registered
diff --git a/man/rdma_post_recv.3 b/man/rdma_post_recv.3
index 5ac0091..6633cef 100644
--- a/man/rdma_post_recv.3
+++ b/man/rdma_post_recv.3
@@ -26,6 +26,9 @@ A registered memory region associated with the posted buffer.
 Posts a work request to the receive queue of the queue pair associated
 with the rdma_cm_id.  The posted buffer will be queued to receive an incoming
 message sent by the remote peer.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 The user is responsible for ensuring that a receive buffer is posted
 and large enough to contain all sent data before the peer posts the
diff --git a/man/rdma_post_recvv.3 b/man/rdma_post_recvv.3
index c230003..f5e099e 100644
--- a/man/rdma_post_recvv.3
+++ b/man/rdma_post_recvv.3
@@ -23,6 +23,9 @@ The number of scatter-gather entries in the sgl array.
 Posts a single work request to the receive queue of the queue pair associated
 with the rdma_cm_id.  The posted buffers will be queued to receive an
 incoming message sent by the remote peer.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 The user is responsible for ensuring that the receive is posted,
 and the total buffer space is large enough to contain all sent data
diff --git a/man/rdma_post_send.3 b/man/rdma_post_send.3
index 3a3b28a..82bcf37 100644
--- a/man/rdma_post_send.3
+++ b/man/rdma_post_send.3
@@ -29,6 +29,9 @@ Optional flags used to control the send operation.
 Posts a work request to the send queue of the queue pair associated
 with the rdma_cm_id.  The contents of the posted buffer will be sent
 to the remote peer of a connection.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 The user is responsible for ensuring that the remote peer has queued a
 receive request before issuing the send operations.  For a list of
diff --git a/man/rdma_post_sendv.3 b/man/rdma_post_sendv.3
index dedf15b..1953ce3 100644
--- a/man/rdma_post_sendv.3
+++ b/man/rdma_post_sendv.3
@@ -26,6 +26,9 @@ Optional flags used to control the send operation.
 Posts a work request to the send queue of the queue pair associated
 with the rdma_cm_id.  The contents of the posted buffers will be sent
 to the remote peer of a connection.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 The user is responsible for ensuring that the remote peer has queued a
 receive request before issuing the send operations.  For a list of
diff --git a/man/rdma_post_ud_send.3 b/man/rdma_post_ud_send.3
index 73fb504..f8e2ada 100644
--- a/man/rdma_post_ud_send.3
+++ b/man/rdma_post_ud_send.3
@@ -35,6 +35,9 @@ The number of the destination queue pair.
 Posts a work request to the send queue of the queue pair associated
 with the rdma_cm_id.  The contents of the posted buffer will be sent
 to the specified destination queue pair.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 The user is responsible for ensuring that the destination queue pair
 has queued a receive request before issuing the send operations.  For a list of
diff --git a/man/rdma_post_write.3 b/man/rdma_post_write.3
index 325b8ac..896996c 100644
--- a/man/rdma_post_write.3
+++ b/man/rdma_post_write.3
@@ -35,6 +35,9 @@ The registered memory key associated with the remote address.
 Posts a work request to the send queue of the queue pair associated
 with the rdma_cm_id.  The contents of the local data buffer will be
 writen into the remote memory region.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 For a list of supported flags, see ibv_post_send.  Unless inline
 data is specified, the local data buffer must have been registered
diff --git a/man/rdma_post_writev.3 b/man/rdma_post_writev.3
index 642b642..f5b23fd 100644
--- a/man/rdma_post_writev.3
+++ b/man/rdma_post_writev.3
@@ -32,6 +32,9 @@ The registered memory key associated with the remote address.
 Posts a work request to the send queue of the queue pair associated
 with the rdma_cm_id.  The contents of the local data buffers will be
 writen into the remote memory region.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 For a list of supported flags, see ibv_post_send.  Unless inline
 data is specified, the local data buffers must have been registered
diff --git a/man/rdma_reg_msgs.3 b/man/rdma_reg_msgs.3
index 224bcad..c2c9359 100644
--- a/man/rdma_reg_msgs.3
+++ b/man/rdma_reg_msgs.3
@@ -22,6 +22,9 @@ messages or for RDMA operations.  Memory buffers registered using
 rdma_reg_msgs may be posted to an rdma_cm_id using
 rdma_post_send or rdma_post_recv, or specified as the target of an RDMA
 read operation or the source of an RDMA write reqeust.
+.SH "RETURN VALUE"
+Returns a reference to the registered memory region on success, or NULL on
+error.  If an error occurs, errno will be set to indicate the failure reason.
 .SH "NOTES"
 rdma_reg_msgs is used to register an array of data buffers
 that will be used send and/or receive messages on a queue pair associated with
diff --git a/man/rdma_reg_read.3 b/man/rdma_reg_read.3
index 31aba35..84417a5 100644
--- a/man/rdma_reg_read.3
+++ b/man/rdma_reg_read.3
@@ -22,6 +22,9 @@ operation.  Memory buffers registered using rdma_reg_read may be
 targeted in an RDMA read request, allowing the buffer to be
 specified on the remote side of an RDMA connection as the remote_addr
 of rdma_post_read, or similar call.
+.SH "RETURN VALUE"
+Returns a reference to the registered memory region on success, or NULL on
+error.  If an error occurs, errno will be set to indicate the failure reason.
 .SH "NOTES"
 rdma_reg_read is used to register a data buffer that will be the
 target of an RDMA read operation on a queue pair associated with
diff --git a/man/rdma_reg_write.3 b/man/rdma_reg_write.3
index 956b362..cc7beea 100644
--- a/man/rdma_reg_write.3
+++ b/man/rdma_reg_write.3
@@ -22,6 +22,9 @@ operation.  Memory buffers registered using rdma_reg_write may be
 targeted in an RDMA write request, allowing the buffer to be
 specified on the remote side of an RDMA connection as the remote_addr
 of rdma_post_write, or similar call.
+.SH "RETURN VALUE"
+Returns a reference to the registered memory region on success, or NULL on
+error.  If an error occurs, errno will be set to indicate the failure reason.
 .SH "NOTES"
 rdma_reg_write is used to register a data buffer that will be the
 target of an RDMA write operation on a queue pair associated with
diff --git a/man/rdma_reject.3 b/man/rdma_reject.3
index dc32160..268f0b3 100644
--- a/man/rdma_reject.3
+++ b/man/rdma_reject.3
@@ -20,6 +20,9 @@ be larger than that requested.
 .SH "DESCRIPTION"
 Called from the listening side to reject a connection or datagram
 service lookup request.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 After receiving a connection request event, a user may call rdma_reject
 to reject the request.  If the underlying RDMA transport supports
diff --git a/man/rdma_resolve_addr.3 b/man/rdma_resolve_addr.3
index e612606..3243c79 100644
--- a/man/rdma_resolve_addr.3
+++ b/man/rdma_resolve_addr.3
@@ -22,6 +22,9 @@ Time to wait for resolution to complete.
 Resolve destination and optional source addresses from IP addresses
 to an RDMA address.  If successful, the specified rdma_cm_id will
 be bound to a local device.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 This call is used to map a given destination IP address to a usable RDMA
 address.  The IP to RDMA address mapping is done using the local routing
diff --git a/man/rdma_resolve_route.3 b/man/rdma_resolve_route.3
index ac1b3bc..c52f1b3 100644
--- a/man/rdma_resolve_route.3
+++ b/man/rdma_resolve_route.3
@@ -16,6 +16,9 @@ Time to wait for resolution to complete.
 Resolves an RDMA route to the destination address in order to establish
 a connection.  The destination address must have already been resolved
 by calling rdma_resolve_addr.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 This is called on the client side of a connection after calling
 rdma_resolve_addr, but before calling rdma_connect.
diff --git a/man/rdma_set_option.3 b/man/rdma_set_option.3
index ffa516c..8e344ab 100644
--- a/man/rdma_set_option.3
+++ b/man/rdma_set_option.3
@@ -24,6 +24,9 @@ The size of the %optval buffer.
 .SH "DESCRIPTION"
 Sets communication options for an rdma_cm_id.  This call is used to override
 the default system settings.
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
 .SH "NOTES"
 Option details may be found in the relevent header files.
 .SH "SEE ALSO"


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
