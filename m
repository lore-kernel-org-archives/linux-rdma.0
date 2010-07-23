From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/6] librdmacm/man: add man pages for calls in rdma_verbs.h
Date: Thu, 22 Jul 2010 21:10:18 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A732D5F5@orsmsx501.amr.corp.intel.com>
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

rdma_verbs.h defines several inline functions that wrap around verb
routines.  Add man pages for these calls.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am              |   17 +++++++++++++
 man/rdma_client.1        |   31 +++++++++++++++++++++++
 man/rdma_cm.7            |   62 +++++++++++++++++++++++++++++++++++++++-------
 man/rdma_dereg_mr.3      |   25 +++++++++++++++++++
 man/rdma_get_recv_comp.3 |   28 +++++++++++++++++++++
 man/rdma_get_send_comp.3 |   28 +++++++++++++++++++++
 man/rdma_post_read.3     |   52 +++++++++++++++++++++++++++++++++++++++
 man/rdma_post_readv.3    |   49 ++++++++++++++++++++++++++++++++++++
 man/rdma_post_recv.3     |   47 +++++++++++++++++++++++++++++++++++
 man/rdma_post_recvv.3    |   44 +++++++++++++++++++++++++++++++++
 man/rdma_post_send.3     |   48 ++++++++++++++++++++++++++++++++++++
 man/rdma_post_sendv.3    |   45 +++++++++++++++++++++++++++++++++
 man/rdma_post_ud_send.3  |   51 ++++++++++++++++++++++++++++++++++++++
 man/rdma_post_write.3    |   52 +++++++++++++++++++++++++++++++++++++++
 man/rdma_post_writev.3   |   49 ++++++++++++++++++++++++++++++++++++
 man/rdma_reg_msgs.3      |   39 +++++++++++++++++++++++++++++
 man/rdma_reg_read.3      |   38 ++++++++++++++++++++++++++++
 man/rdma_reg_write.3     |   38 ++++++++++++++++++++++++++++
 man/rdma_server.1        |   26 +++++++++++++++++++
 19 files changed, 760 insertions(+), 9 deletions(-)
 create mode 100644 man/rdma_client.1
 create mode 100644 man/rdma_dereg_mr.3
 create mode 100644 man/rdma_get_recv_comp.3
 create mode 100644 man/rdma_get_send_comp.3
 create mode 100644 man/rdma_post_read.3
 create mode 100644 man/rdma_post_readv.3
 create mode 100644 man/rdma_post_recv.3
 create mode 100644 man/rdma_post_recvv.3
 create mode 100644 man/rdma_post_send.3
 create mode 100644 man/rdma_post_sendv.3
 create mode 100644 man/rdma_post_ud_send.3
 create mode 100644 man/rdma_post_write.3
 create mode 100644 man/rdma_post_writev.3
 create mode 100644 man/rdma_reg_msgs.3
 create mode 100644 man/rdma_reg_read.3
 create mode 100644 man/rdma_reg_write.3
 create mode 100644 man/rdma_server.1

diff --git a/Makefile.am b/Makefile.am
index c752b4f..2668aa3 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -74,10 +74,27 @@ man_MANS = \
        man/rdma_create_ep.3 \
        man/rdma_destroy_ep.3 \
        man/rdma_getaddrinfo.3 \
+       man/rdma_dereg_mr.3 \
+       man/rdma_get_recv_comp.3 \
+       man/rdma_get_send_comp.3 \
+       man/rdma_post_read.3 \
+       man/rdma_post_readv.3 \
+       man/rdma_post_recv.3 \
+       man/rdma_post_recvv.3 \
+       man/rdma_post_send.3 \
+       man/rdma_post_sendv.3 \
+       man/rdma_post_ud_send.3 \
+       man/rdma_post_write.3 \
+       man/rdma_post_writev.3 \
+       man/rdma_reg_msgs.3 \
+       man/rdma_reg_read.3 \
+       man/rdma_reg_write.3 \
        man/ucmatose.1 \
        man/udaddy.1 \
        man/mckey.1 \
        man/rping.1 \
+       man/rdma_server.1 \
+       man/rdma_client.1 \
        man/rdma_cm.7

 EXTRA_DIST = include/rdma/rdma_cma_abi.h include/rdma/rdma_cma.h \
diff --git a/man/rdma_client.1 b/man/rdma_client.1
new file mode 100644
index 0000000..68bfc76
--- /dev/null
+++ b/man/rdma_client.1
@@ -0,0 +1,31 @@
+.TH "RDMA_CLIENT" 1 "2010-07-19" "librdmacm" "librdmacm" librdmacm
+.SH NAME
+rdma_client \- simple RDMA CM connection and ping-pong test.
+.SH SYNOPSIS
+.sp
+.nf
+\fIrdma_client\fR [-s server_address] [-p server_port]
+.fi
+.SH "DESCRIPTION"
+Uses synchronous librdmam calls to establish an RDMA connection between
+two nodes.  This example is intended to provide a very simple coding
+example of how to use RDMA.
+.SH "OPTIONS"
+.TP
+\-s server_address
+Specifies the address of the system that the rdma_server is running on.
+By default, the client will attempt to connect to the server using
+127.0.0.1.
+.TP
+\-p server_port
+Specifies the port number that the server listens on.  By default the server
+listens on port 7471.
+.SH "NOTES"
+Basic usage is to start rdma_server, then connect to the server using the
+rdma_client program.
+.P
+Because this test maps RDMA resources to userspace, users must ensure
+that they have available system resources and permissions.  See the
+libibverbs README file for additional details.
+.SH "SEE ALSO"
+rdma_cm(7), udaddy(1), mckey(1), rping(1), rdma_server(1)
diff --git a/man/rdma_cm.7 b/man/rdma_cm.7
index ff5d489..8dd0649 100644
--- a/man/rdma_cm.7
+++ b/man/rdma_cm.7
@@ -163,12 +163,56 @@ related to ENOMEM, ENODEV, ENODATA, EINVAL, and EADDRNOTAVAIL codes. Application
 that want to check these codes and have compatability with prior library versions
 must manually set errno to the negative of the return code if it is < -1.
 .SH "SEE ALSO"
-rdma_create_event_channel(3), rdma_get_cm_event(3), rdma_create_id(3),
-rdma_resolve_addr(3), rdma_bind_addr(3), rdma_create_qp(3),
-rdma_resolve_route(3), rdma_connect(3), rdma_listen(3), rdma_accept(3),
-rdma_reject(3), rdma_join_multicast(3), rdma_leave_multicast(3), rdma_notify(3),
-rdma_ack_cm_event(3), rdma_disconnect(3), rdma_destroy_qp(3), rdma_destroy_id(3),
-rdma_destroy_event_channel(3), rdma_get_devices(3), rdma_free_devices(3),
-rdma_get_peer_addr(3), rdma_get_local_addr(3),
-rdma_get_dst_port(3), rdma_get_src_port(3), rdma_set_option(3)
-ucmatose(1), udaddy(1), mckey(1), rping(1)
+rdma_accept(3),
+rdma_ack_cm_event(3),
+rdma_bind_addr(3),
+rdma_connect(3),
+rdma_create_ep(3),
+rdma_create_event_channel(3),
+rdma_create_id(3),
+rdma_create_qp(3),
+rdma_dereg_mr(3),
+rdma_destroy_ep(3),
+rdma_destroy_event_channel(3),
+rdma_destroy_id(3),
+rdma_destroy_qp(3),
+rdma_disconnect(3),
+rdma_event_str(3),
+rdma_free_devices(3),
+rdma_getaddrinfo(3),
+rdma_get_cm_event(3),
+rdma_get_devices(3),
+rdma_get_dst_port(3),
+rdma_get_local_addr(3),
+rdma_get_peer_addr(3),
+rdma_get_recv_comp(3),
+rdma_get_request(3),
+rdma_get_send_comp(3),
+rdma_get_src_port(3),
+rdma_join_multicast(3),
+rdma_leave_multicast(3),
+rdma_listen(3),
+rdma_migrate_id(3),
+rdma_notify(3),
+rdma_post_read(3)
+rdma_post_readv(3),
+rdma_post_recv(3),
+rdma_post_recvv(3),
+rdma_post_send(3),
+rdma_post_sendv(3),
+rdma_post_ud_send(3),
+rdma_post_write(3),
+rdma_post_writev(3),
+rdma_reg_msgs(3),
+rdma_reg_read(3),
+rdma_reg_write(3),
+rdma_reject(3),
+rdma_resolve_addr(3),
+rdma_resolve_route(3),
+rdma_set_option(3)
+mckey(1),
+rdma_client(1),
+rdma_server(1),
+rping(1),
+ucmatose(1),
+udaddy(1)
diff --git a/man/rdma_dereg_mr.3 b/man/rdma_dereg_mr.3
new file mode 100644
index 0000000..f4d46f1
--- /dev/null
+++ b/man/rdma_dereg_mr.3
@@ -0,0 +1,25 @@
+.TH "RDMA_DEREG_MR" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.SH NAME
+rdma_dereg_mr \- deregisters a registered memory region.
+.SH SYNOPSIS
+.B "#include <rdma/rdma_verbs.h>"
+.P
+.B "struct ibv_mr *" rdma_dereg_mr
+.BI "(struct ibv_mr *" mr ");"
+.SH ARGUMENTS
+.IP "mr" 12
+A reference to a registered memory buffer.
+.SH "DESCRIPTION"
+Deregisters a memory buffer that had been registered for RDMA
+or message operations.  A user should call rdma_dereg_mr for all
+registered memory associated with an rdma_cm_id before destroying
+the rdma_cm_id.
+.SH "NOTES"
+All memory registered with an rdma_cm_id is associated with the
+protection domain associated with the id.  Users must deregister
+all registered memory before the protection domain can be destroyed.
+.SH "SEE ALSO"
+rdma_cm(7), rdma_create_id(3), rdma_create_ep(3),
+rdma_destroy_id(3), rdma_destroy_ep(3),
+rdma_reg_msgs(3), rdma_reg_read(3), rdma_reg_write(3),
+ibv_reg_mr(3), ibv_dereg_mr(3)
diff --git a/man/rdma_get_recv_comp.3 b/man/rdma_get_recv_comp.3
new file mode 100644
index 0000000..349c505
--- /dev/null
+++ b/man/rdma_get_recv_comp.3
@@ -0,0 +1,28 @@
+.TH "RDMA_GET_RECV_COMP" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.SH NAME
+rdma_get_recv_comp \- retrieves a completed receive request.
+.SH SYNOPSIS
+.B "#include <rdma/rdma_verbs.h>"
+.P
+.B "int" rdma_get_recv_comp
+.BI "(struct rdma_cm_id *" id ","
+.BI "struct ibv_wc *" wc ");"
+.SH ARGUMENTS
+.IP "id" 12
+A reference to a communication identifier to check for completions.
+.IP "wc" 12
+A reference to a work completion structure to fill in.
+.SH "DESCRIPTION"
+Retrieves a completed work request for a receive
+operation.  Information about the completed request is returned through
+the wc parameter, with the wr_id set to the context of the request.  For
+details on the work completion structure, see ibv_poll_cq.
+.SH "NOTES"
+This calls polls the receive completion queue associated with an rdma_cm_id.
+If a completion is not found, the call blocks until a request completes.
+This call should only be used on rdma_cm_id's that do not share CQs
+with other rdma_cm_id's, and maintain separate CQs for sends and receive
+completions.
+.SH "SEE ALSO"
+rdma_cm(7), ibv_poll_cq(3), rdma_get_send_comp(3),
+rdma_post_send(3), rdma_post_read(3), rdma_post_write(3)
diff --git a/man/rdma_get_send_comp.3 b/man/rdma_get_send_comp.3
new file mode 100644
index 0000000..2775b7d
--- /dev/null
+++ b/man/rdma_get_send_comp.3
@@ -0,0 +1,28 @@
+.TH "RDMA_GET_SEND_COMP" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.SH NAME
+rdma_get_send_comp \- retrieves a completed send, read, or write request.
+.SH SYNOPSIS
+.B "#include <rdma/rdma_verbs.h>"
+.P
+.B "int" rdma_get_send_comp
+.BI "(struct rdma_cm_id *" id ","
+.BI "struct ibv_wc *" wc ");"
+.SH ARGUMENTS
+.IP "id" 12
+A reference to a communication identifier to check for completions.
+.IP "wc" 12
+A reference to a work completion structure to fill in.
+.SH "DESCRIPTION"
+Retrieves a completed work request for a send, RDMA read, or RDMA write
+operation.  Information about the completed request is returned through
+the wc parameter, with the wr_id set to the context of the request.  For
+details on the work completion structure, see ibv_poll_cq.
+.SH "NOTES"
+This calls polls the send completion queue associated with an rdma_cm_id.
+If a completion is not found, the call blocks until a request completes.
+This call should only be used on rdma_cm_id's that do not share CQs
+with other rdma_cm_id's, and maintain separate CQs for sends and receive
+completions.
+.SH "SEE ALSO"
+rdma_cm(7), ibv_poll_cq(3), rdma_get_recv_comp(3),
+rdma_post_send(3), rdma_post_read(3), rdma_post_write(3)
diff --git a/man/rdma_post_read.3 b/man/rdma_post_read.3
new file mode 100644
index 0000000..faf6979
--- /dev/null
+++ b/man/rdma_post_read.3
@@ -0,0 +1,52 @@
+.TH "RDMA_POST_READ" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.SH NAME
+rdma_post_read \- post an RDMA read work request.
+.SH SYNOPSIS
+.B "#include <rdma/rdma_verbs.h>"
+.P
+.B "int" rdma_post_read
+.BI "(struct rdma_cm_id *" id ","
+.BI "void *" context ","
+.BI "void *" addr ","
+.BI "size_t " length ","
+.BI "struct ibv_mr *" mr ","
+.BI "int " flags ","
+.BI "uint64_t " remote_addr ","
+.BI "uint32_t " rkey ");"
+.SH ARGUMENTS
+.IP "id" 12
+A reference to a communication identifier where the request
+will be posted.
+.IP "context" 12
+User-defined context associated with the request.
+.IP "addr" 12
+The address of the local destination of the read request.
+.IP "length" 12
+The length of the read operation.
+.IP "mr" 12
+Registered memory region associated with the local buffer.
+.IP "flags" 12
+Optional flags used to control the read operation.
+.IP "remote_addr" 12
+The address of the remote registered memory to read from.
+.IP "rkey" 12
+The registered memory key associated with the remote address.
+.SH "DESCRIPTION"
+Posts a work request to the send queue of the queue pair associated
+with the rdma_cm_id.  The contents of the remote memory region will be
+read into the local data buffer.
+.SH "NOTES"
+For a list of supported flags, see ibv_post_send.
+Both the remote and local data buffers must have been registered
+before the read is issued, and the buffers must remain registered
+until the read completes.
+.P
+Read operations may not be posted to an rdma_cm_id or the corresponding
+queue pair until it has been connected.
+.P
+The user-defined context associated with the read request will be
+returned to the user through the work completion wr_id, work request
+identifier, field.
+.SH "SEE ALSO"
+rdma_cm(7), rdma_connect(3), rdma_accept(3),
+ibv_post_send(3), rdma_post_readv(3), rdma_reg_read(3), rdma_reg_msgs(3)
diff --git a/man/rdma_post_readv.3 b/man/rdma_post_readv.3
new file mode 100644
index 0000000..185474f
--- /dev/null
+++ b/man/rdma_post_readv.3
@@ -0,0 +1,49 @@
+.TH "RDMA_POST_READV" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.SH NAME
+rdma_post_readv \- post an RDMA read work request.
+.SH SYNOPSIS
+.B "#include <rdma/rdma_verbs.h>"
+.P
+.B "int" rdma_post_readv
+.BI "(struct rdma_cm_id *" id ","
+.BI "void *" context ","
+.BI "struct ibv_sge *" sgl ","
+.BI "int " nsge ","
+.BI "int " flags ","
+.BI "uint64_t " remote_addr ","
+.BI "uint32_t " rkey ");"
+.SH ARGUMENTS
+.IP "id" 12
+A reference to a communication identifier where the request
+will be posted.
+.IP "context" 12
+User-defined context associated with the request.
+.IP "sgl" 12
+A scatter-gather list of the destination buffers of the read.
+.IP "nsge" 12
+The number of scatter-gather array entries.
+.IP "flags" 12
+Optional flags used to control the read operation.
+.IP "remote_addr" 12
+The address of the remote registered memory to read from.
+.IP "rkey" 12
+The registered memory key associated with the remote address.
+.SH "DESCRIPTION"
+Posts a work request to the send queue of the queue pair associated
+with the rdma_cm_id.  The contents of the remote memory region will be
+read into the local data buffers.
+.SH "NOTES"
+For a list of supported flags, see ibv_post_send.
+Both the remote and local data buffers must have been registered
+before the read is issued, and the buffers must remain registered
+until the read completes.
+.P
+Read operations may not be posted to an rdma_cm_id or the corresponding
+queue pair until it has been connected.
+.P
+The user-defined context associated with the read request will be
+returned to the user through the work completion wr_id, work request
+identifier, field.
+.SH "SEE ALSO"
+rdma_cm(7), rdma_connect(3), rdma_accept(3),
+ibv_post_send(3), rdma_post_read(3), rdma_reg_read(3), rdma_reg_msgs(3)
diff --git a/man/rdma_post_recv.3 b/man/rdma_post_recv.3
new file mode 100644
index 0000000..5ac0091
--- /dev/null
+++ b/man/rdma_post_recv.3
@@ -0,0 +1,47 @@
+.TH "RDMA_POST_RECV" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.SH NAME
+rdma_post_recv \- post a work request to receive an incoming message.
+.SH SYNOPSIS
+.B "#include <rdma/rdma_verbs.h>"
+.P
+.B "int" rdma_post_recv
+.BI "(struct rdma_cm_id *" id ","
+.BI "void *" context ","
+.BI "void *" addr ","
+.BI "size_t " length ","
+.BI "struct ibv_mr *" mr ");"
+.SH ARGUMENTS
+.IP "id" 12
+A reference to a communication identifier where the message buffer
+will be posted.
+.IP "context" 12
+User-defined context associated with the request.
+.IP "addr" 12
+The address of the memory buffer to post.
+.IP "length" 12
+The length of the memory buffer.
+.IP "mr" 12
+A registered memory region associated with the posted buffer.
+.SH "DESCRIPTION"
+Posts a work request to the receive queue of the queue pair associated
+with the rdma_cm_id.  The posted buffer will be queued to receive an incoming
+message sent by the remote peer.
+.SH "NOTES"
+The user is responsible for ensuring that a receive buffer is posted
+and large enough to contain all sent data before the peer posts the
+corresponding send message.  The message buffer must have been registered
+before being posted, with the mr parameter referencing the registration.
+The buffer must remain registered until the receive completes.
+.P
+Messages may be posted to an rdma_cm_id only after a queue pair has
+been associated with it.  A queue pair is bound to an rdma_cm_id after
+calling rdma_create_ep or rdma_create_qp, if the rdma_cm_id is allocated
+using rdma_create_id.
+.P
+The user-defined context associated with the receive request will be
+returned to the user through the work completion wr_id, work request
+identifier, field.
+.SH "SEE ALSO"
+rdma_cm(7), rdma_create_id(3), rdma_create_ep(3), rdma_create_qp(3),
+rdma_reg_read(3), ibv_reg_mr(3), ibv_dereg_mr(3),
+rdma_post_recvv(3), rdma_post_send(3)
diff --git a/man/rdma_post_recvv.3 b/man/rdma_post_recvv.3
new file mode 100644
index 0000000..c230003
--- /dev/null
+++ b/man/rdma_post_recvv.3
@@ -0,0 +1,44 @@
+.TH "RDMA_POST_RECVV" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.SH NAME
+rdma_post_recvv \- post a work request to receive incoming messages.
+.SH SYNOPSIS
+.B "#include <rdma/rdma_verbs.h>"
+.P
+.B "int" rdma_post_recvv
+.BI "(struct rdma_cm_id *" id ","
+.BI "void *" context ","
+.BI "struct ibv_sge *" sgl ","
+.BI "int " nsge ");"
+.SH ARGUMENTS
+.IP "id" 12
+A reference to a communication identifier where the message buffer(s)
+will be posted.
+.IP "context" 12
+User-defined context associated with the request.
+.IP "sgl" 12
+A scatter-gather list of memory buffers posted as a single request.
+.IP "nsge" 12
+The number of scatter-gather entries in the sgl array.
+.SH "DESCRIPTION"
+Posts a single work request to the receive queue of the queue pair associated
+with the rdma_cm_id.  The posted buffers will be queued to receive an
+incoming message sent by the remote peer.
+.SH "NOTES"
+The user is responsible for ensuring that the receive is posted,
+and the total buffer space is large enough to contain all sent data
+before the peer posts the corresponding send message.  The message buffers
+must have been registered before being posted, and the buffers must
+remain registered until the receive completes.
+.P
+Messages may be posted to an rdma_cm_id only after a queue pair has
+been associated with it.  A queue pair is bound to an rdma_cm_id after
+calling rdma_create_ep or rdma_create_qp, if the rdma_cm_id is allocated
+using rdma_create_id.
+.P
+The user-defined context associated with the receive request will be
+returned to the user through the work completion wr_id, work request
+identifier, field.
+.SH "SEE ALSO"
+rdma_cm(7), rdma_create_id(3), rdma_create_ep(3), rdma_create_qp(3),
+rdma_reg_read(3), ibv_reg_mr(3), ibv_dereg_mr(3),
+rdma_post_recv(3), rdma_post_send(3)
diff --git a/man/rdma_post_send.3 b/man/rdma_post_send.3
new file mode 100644
index 0000000..3a3b28a
--- /dev/null
+++ b/man/rdma_post_send.3
@@ -0,0 +1,48 @@
+.TH "RDMA_POST_SEND" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.SH NAME
+rdma_post_send \- post a work request to send a message.
+.SH SYNOPSIS
+.B "#include <rdma/rdma_verbs.h>"
+.P
+.B "int" rdma_post_send
+.BI "(struct rdma_cm_id *" id ","
+.BI "void *" context ","
+.BI "void *" addr ","
+.BI "size_t " length ","
+.BI "struct ibv_mr *" mr ","
+.BI "int " flags ");"
+.SH ARGUMENTS
+.IP "id" 12
+A reference to a communication identifier where the message buffer
+will be posted.
+.IP "context" 12
+User-defined context associated with the request.
+.IP "addr" 12
+The address of the memory buffer to post.
+.IP "length" 12
+The length of the memory buffer.
+.IP "mr" 12
+Optional registered memory region associated with the posted buffer.
+.IP "flags" 12
+Optional flags used to control the send operation.
+.SH "DESCRIPTION"
+Posts a work request to the send queue of the queue pair associated
+with the rdma_cm_id.  The contents of the posted buffer will be sent
+to the remote peer of a connection.
+.SH "NOTES"
+The user is responsible for ensuring that the remote peer has queued a
+receive request before issuing the send operations.  For a list of
+supported flags, see ibv_post_send.  Unless the send request is using
+inline data, the message buffer must have been registered
+before being posted, with the mr parameter referencing the registration.
+The buffer must remain registered until the send completes.
+.P
+Send operations may not be posted to an rdma_cm_id or the corresponding
+queue pair until it has been connected.
+.P
+The user-defined context associated with the send request will be
+returned to the user through the work completion wr_id, work request
+identifier, field.
+.SH "SEE ALSO"
+rdma_cm(7), rdma_connect(3), rdma_accept(3),
+ibv_post_send(3), rdma_post_sendv(3), rdma_post_recv(3)
diff --git a/man/rdma_post_sendv.3 b/man/rdma_post_sendv.3
new file mode 100644
index 0000000..dedf15b
--- /dev/null
+++ b/man/rdma_post_sendv.3
@@ -0,0 +1,45 @@
+.TH "RDMA_POST_SENDV" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.SH NAME
+rdma_post_sendv \- post a work request to send a message.
+.SH SYNOPSIS
+.B "#include <rdma/rdma_verbs.h>"
+.P
+.B "int" rdma_post_sendv
+.BI "(struct rdma_cm_id *" id ","
+.BI "void *" context ","
+.BI "struct ibv_sge *" slg ","
+.BI "int " nsge ","
+.BI "int " flags ");"
+.SH ARGUMENTS
+.IP "id" 12
+A reference to a communication identifier where the message buffer
+will be posted.
+.IP "context" 12
+User-defined context associated with the request.
+.IP "slg" 12
+A scatter-gather list of memory buffers posted as a single request.
+.IP "nsge" 12
+The number of scatter-gather entries in the slg array.
+.IP "flags" 12
+Optional flags used to control the send operation.
+.SH "DESCRIPTION"
+Posts a work request to the send queue of the queue pair associated
+with the rdma_cm_id.  The contents of the posted buffers will be sent
+to the remote peer of a connection.
+.SH "NOTES"
+The user is responsible for ensuring that the remote peer has queued a
+receive request before issuing the send operations.  For a list of
+supported flags, see ibv_post_send.  Unless the send request is using
+inline data, the message buffers must have been registered
+before being posted, and the buffers must remain registered
+until the send completes.
+.P
+Send operations may not be posted to an rdma_cm_id or the corresponding
+queue pair until it has been connected.
+.P
+The user-defined context associated with the send request will be
+returned to the user through the work completion wr_id, work request
+identifier, field.
+.SH "SEE ALSO"
+rdma_cm(7), rdma_connect(3), rdma_accept(3),
+ibv_post_send(3), rdma_post_send(3), rdma_post_recv(3)
diff --git a/man/rdma_post_ud_send.3 b/man/rdma_post_ud_send.3
new file mode 100644
index 0000000..73fb504
--- /dev/null
+++ b/man/rdma_post_ud_send.3
@@ -0,0 +1,51 @@
+.TH "RDMA_POST_UD_SEND" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.SH NAME
+rdma_post_ud_send \- post a work request to send a datagram.
+.SH SYNOPSIS
+.B "#include <rdma/rdma_verbs.h>"
+.P
+.B "int" rdma_post_ud_send
+.BI "(struct rdma_cm_id *" id ","
+.BI "void *" context ","
+.BI "void *" addr ","
+.BI "size_t " length ","
+.BI "struct ibv_mr *" mr ","
+.BI "int " flags ","
+.BI "struct ibv_ah *" ah ","
+.BI "uint32_t " remote_qpn ");"
+.SH ARGUMENTS
+.IP "id" 12
+A reference to a communication identifier where the message buffer
+will be posted.
+.IP "context" 12
+User-defined context associated with the request.
+.IP "addr" 12
+The address of the memory buffer to post.
+.IP "length" 12
+The length of the memory buffer.
+.IP "mr" 12
+Optional registered memory region associated with the posted buffer.
+.IP "flags" 12
+Optional flags used to control the send operation.
+.IP "ah" 12
+An address handle describing the address of the remote node.
+.IP "remote_qpn" 12
+The number of the destination queue pair.
+.SH "DESCRIPTION"
+Posts a work request to the send queue of the queue pair associated
+with the rdma_cm_id.  The contents of the posted buffer will be sent
+to the specified destination queue pair.
+.SH "NOTES"
+The user is responsible for ensuring that the destination queue pair
+has queued a receive request before issuing the send operations.  For a list of
+supported flags, see ibv_post_send.  Unless the send request is using
+inline data, the message buffer must have been registered
+before being posted, with the mr parameter referencing the registration.
+The buffer must remain registered until the send completes.
+.P
+The user-defined context associated with the send request will be
+returned to the user through the work completion wr_id, work request
+identifier, field.
+.SH "SEE ALSO"
+rdma_cm(7), rdma_connect(3), rdma_accept(3), rdma_reg_msgs(3)
+ibv_post_send(3), rdma_post_recv(3)
diff --git a/man/rdma_post_write.3 b/man/rdma_post_write.3
new file mode 100644
index 0000000..325b8ac
--- /dev/null
+++ b/man/rdma_post_write.3
@@ -0,0 +1,52 @@
+.TH "RDMA_POST_WRITE" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.SH NAME
+rdma_post_write \- post an RDMA write work request.
+.SH SYNOPSIS
+.B "#include <rdma/rdma_verbs.h>"
+.P
+.B "int" rdma_post_write
+.BI "(struct rdma_cm_id *" id ","
+.BI "void *" context ","
+.BI "void *" addr ","
+.BI "size_t " length ","
+.BI "struct ibv_mr *" mr ","
+.BI "int " flags ","
+.BI "uint64_t " remote_addr ","
+.BI "uint32_t " rkey ");"
+.SH ARGUMENTS
+.IP "id" 12
+A reference to a communication identifier where the request
+will be posted.
+.IP "context" 12
+User-defined context associated with the request.
+.IP "addr" 12
+The local address of the source of the write request.
+.IP "length" 12
+The length of the write operation.
+.IP "mr" 12
+Optional memory region associated with the local buffer.
+.IP "flags" 12
+Optional flags used to control the write operation.
+.IP "remote_addr" 12
+The address of the remote registered memory to write into.
+.IP "rkey" 12
+The registered memory key associated with the remote address.
+.SH "DESCRIPTION"
+Posts a work request to the send queue of the queue pair associated
+with the rdma_cm_id.  The contents of the local data buffer will be
+writen into the remote memory region.
+.SH "NOTES"
+For a list of supported flags, see ibv_post_send.  Unless inline
+data is specified, the local data buffer must have been registered
+before the write is issued, and the buffer must remain registered
+until the write completes.  The remote buffer must always be registered.
+.P
+Write operations may not be posted to an rdma_cm_id or the corresponding
+queue pair until it has been connected.
+.P
+The user-defined context associated with the write request will be
+returned to the user through the work completion wr_id, work request
+identifier, field.
+.SH "SEE ALSO"
+rdma_cm(7), rdma_connect(3), rdma_accept(3),
+ibv_post_send(3), rdma_post_writev(3), rdma_reg_write(3), rdma_reg_msgs(3)
diff --git a/man/rdma_post_writev.3 b/man/rdma_post_writev.3
new file mode 100644
index 0000000..642b642
--- /dev/null
+++ b/man/rdma_post_writev.3
@@ -0,0 +1,49 @@
+.TH "RDMA_POST_WRITEV" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.SH NAME
+rdma_post_writev \- post an RDMA write work request.
+.SH SYNOPSIS
+.B "#include <rdma/rdma_verbs.h>"
+.P
+.B "int" rdma_post_writev
+.BI "(struct rdma_cm_id *" id ","
+.BI "void *" context ","
+.BI "struct ibv_sge *" sgl ","
+.BI "int " nsge ","
+.BI "int " flags ","
+.BI "uint64_t " remote_addr ","
+.BI "uint32_t " rkey ");"
+.SH ARGUMENTS
+.IP "id" 12
+A reference to a communication identifier where the request
+will be posted.
+.IP "context" 12
+User-defined context associated with the request.
+.IP "sgl" 12
+A scatter-gather list of the source buffers of the write.
+.IP "nsge" 12
+The number of scatter-gather array entries.
+.IP "flags" 12
+Optional flags used to control the write operation.
+.IP "remote_addr" 12
+The address of the remote registered memory to write into.
+.IP "rkey" 12
+The registered memory key associated with the remote address.
+.SH "DESCRIPTION"
+Posts a work request to the send queue of the queue pair associated
+with the rdma_cm_id.  The contents of the local data buffers will be
+writen into the remote memory region.
+.SH "NOTES"
+For a list of supported flags, see ibv_post_send.  Unless inline
+data is specified, the local data buffers must have been registered
+before the write is issued, and the buffers must remain registered
+until the write completes.  The remote buffers must always be registered.
+.P
+Write operations may not be posted to an rdma_cm_id or the corresponding
+queue pair until it has been connected.
+.P
+The user-defined context associated with the write request will be
+returned to the user through the work completion wr_id, work request
+identifier, field.
+.SH "SEE ALSO"
+rdma_cm(7), rdma_connect(3), rdma_accept(3),
+ibv_post_send(3), rdma_post_write(3), rdma_reg_write(3), rdma_reg_msgs(3)
diff --git a/man/rdma_reg_msgs.3 b/man/rdma_reg_msgs.3
new file mode 100644
index 0000000..224bcad
--- /dev/null
+++ b/man/rdma_reg_msgs.3
@@ -0,0 +1,39 @@
+.TH "RDMA_REG_MSGS" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.SH NAME
+rdma_reg_msgs \- register data buffer(s) for sending or receiving messages.
+.SH SYNOPSIS
+.B "#include <rdma/rdma_verbs.h>"
+.P
+.B "struct ibv_mr *" rdma_reg_msgs
+.BI "(struct rdma_cm_id *" id ","
+.BI "void *" addr ","
+.BI "size_t " length ");"
+.SH ARGUMENTS
+.IP "id" 12
+A reference to a communication identifier where the message buffer(s)
+will be used.
+.IP "addr" 12
+The address of the memory buffer(s) to register.
+.IP "length" 12
+The total length of the memory to register.
+.SH "DESCRIPTION"
+Registers an array of memory buffers used for sending and receiving
+messages or for RDMA operations.  Memory buffers registered using
+rdma_reg_msgs may be posted to an rdma_cm_id using
+rdma_post_send or rdma_post_recv, or specified as the target of an RDMA
+read operation or the source of an RDMA write reqeust.
+.SH "NOTES"
+rdma_reg_msgs is used to register an array of data buffers
+that will be used send and/or receive messages on a queue pair associated with
+an rdma_cm_id.  The memory buffer is registered with the proteection
+domain associated with the idenfier.  The start of the data buffer array
+is specified through the addr parameter, and the total size of the array
+is given by length.
+.P
+All data buffers should be registered before being posted as a work request.
+Users must deregister all registered memory by calling rdma_dereg_mr.
+.SH "SEE ALSO"
+rdma_cm(7), rdma_create_id(3), rdma_create_ep(3),
+rdma_reg_read(3), rdma_reg_write(3),
+ibv_reg_mr(3), ibv_dereg_mr(3), rdma_post_send(3), rdma_post_recv(3),
+rdma_post_read(3), rdma_post_readv(3), rdma_post_write(3), rdma_post_writev(3)
diff --git a/man/rdma_reg_read.3 b/man/rdma_reg_read.3
new file mode 100644
index 0000000..31aba35
--- /dev/null
+++ b/man/rdma_reg_read.3
@@ -0,0 +1,38 @@
+.TH "RDMA_REG_READ" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.SH NAME
+rdma_reg_read \- register data buffer(s) for remote RDMA read access.
+.SH SYNOPSIS
+.B "#include <rdma/rdma_verbs.h>"
+.P
+.B "struct ibv_mr *" rdma_reg_read
+.BI "(struct rdma_cm_id *" id ","
+.BI "void *" addr ","
+.BI "size_t " length ");"
+.SH ARGUMENTS
+.IP "id" 12
+A reference to a communication identifier where the message buffer(s)
+will be used.
+.IP "addr" 12
+The address of the memory buffer(s) to register.
+.IP "length" 12
+The total length of the memory to register.
+.SH "DESCRIPTION"
+Registers a memory buffer that will be accessed by a remote RDMA read
+operation.  Memory buffers registered using rdma_reg_read may be
+targeted in an RDMA read request, allowing the buffer to be
+specified on the remote side of an RDMA connection as the remote_addr
+of rdma_post_read, or similar call.
+.SH "NOTES"
+rdma_reg_read is used to register a data buffer that will be the
+target of an RDMA read operation on a queue pair associated with
+an rdma_cm_id.  The memory buffer is registered with the proteection
+domain associated with the idenfier.  The start of the data buffer
+is specified through the addr parameter, and the total size of the buffer
+is given by length.
+.P
+All data buffers should be registered before being posted as a work request.
+Users must deregister all registered memory by calling rdma_dereg_mr.
+.SH "SEE ALSO"
+rdma_cm(7), rdma_create_id(3), rdma_create_ep(3),
+rdma_reg_msgs(3), rdma_reg_write(3),
+ibv_reg_mr(3), ibv_dereg_mr(3), rdma_post_read(3)
diff --git a/man/rdma_reg_write.3 b/man/rdma_reg_write.3
new file mode 100644
index 0000000..956b362
--- /dev/null
+++ b/man/rdma_reg_write.3
@@ -0,0 +1,38 @@
+.TH "RDMA_REG_WRITE" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.SH NAME
+rdma_reg_write \- register data buffer(s) for remote RDMA write access.
+.SH SYNOPSIS
+.B "#include <rdma/rdma_verbs.h>"
+.P
+.B "struct ibv_mr *" rdma_reg_write
+.BI "(struct rdma_cm_id *" id ","
+.BI "void *" addr ","
+.BI "size_t " length ");"
+.SH ARGUMENTS
+.IP "id" 12
+A reference to a communication identifier where the message buffer(s)
+will be used.
+.IP "addr" 12
+The address of the memory buffer(s) to register.
+.IP "length" 12
+The total length of the memory to register.
+.SH "DESCRIPTION"
+Registers a memory buffer that will be accessed by a remote RDMA write
+operation.  Memory buffers registered using rdma_reg_write may be
+targeted in an RDMA write request, allowing the buffer to be
+specified on the remote side of an RDMA connection as the remote_addr
+of rdma_post_write, or similar call.
+.SH "NOTES"
+rdma_reg_write is used to register a data buffer that will be the
+target of an RDMA write operation on a queue pair associated with
+an rdma_cm_id.  The memory buffer is registered with the proteection
+domain associated with the idenfier.  The start of the data buffer
+is specified through the addr parameter, and the total size of the buffer
+is given by length.
+.P
+All data buffers should be registered before being posted as a work request.
+Users must deregister all registered memory by calling rdma_dereg_mr.
+.SH "SEE ALSO"
+rdma_cm(7), rdma_create_id(3), rdma_create_ep(3),
+rdma_reg_msgs(3), rdma_reg_read(3),
+ibv_reg_mr(3), ibv_dereg_mr(3), rdma_post_write(3)
diff --git a/man/rdma_server.1 b/man/rdma_server.1
new file mode 100644
index 0000000..19f4860
--- /dev/null
+++ b/man/rdma_server.1
@@ -0,0 +1,26 @@
+.TH "RDMA_SERVER" 1 "2010-07-19" "librdmacm" "librdmacm" librdmacm
+.SH NAME
+rdma_server \- simple RDMA CM connection and ping-pong test.
+.SH SYNOPSIS
+.sp
+.nf
+\fIrdma_server\fR [-p port]
+.fi
+.SH "DESCRIPTION"
+Uses synchronous librdmam calls to establish an RDMA connections between
+two nodes.  This example is intended to provide a very simple coding
+example of how to use RDMA.
+.SH "OPTIONS"
+.TP
+\-p port
+Changes the port number that the server listens on.  By default the server
+listens on port 7471.
+.SH "NOTES"
+Basic usage is to start rdma_server, then connect to the server using the
+rdma_client program.
+.P
+Because this test maps RDMA resources to userspace, users must ensure
+that they have available system resources and permissions.  See the
+libibverbs README file for additional details.
+.SH "SEE ALSO"
+rdma_cm(7), udaddy(1), mckey(1), rping(1), rdma_client(1)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
