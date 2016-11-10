From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 6/8] rdmacm: Push COPYING file into individual files
Date: Thu, 10 Nov 2016 11:47:38 -0700
Message-ID: <1478803660-27959-7-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1478803660-27959-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478803660-27959-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add missing copyright headers and delete the COPYING file.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 librdmacm/COPYING                          | 378 -----------------------------
 librdmacm/docs/rsocket                     |   1 +
 librdmacm/man/mckey.1                      |   1 +
 librdmacm/man/rcopy.1                      |   1 +
 librdmacm/man/rdma_accept.3                |   1 +
 librdmacm/man/rdma_ack_cm_event.3          |   1 +
 librdmacm/man/rdma_bind_addr.3             |   1 +
 librdmacm/man/rdma_client.1                |   1 +
 librdmacm/man/rdma_cm.7                    |   1 +
 librdmacm/man/rdma_connect.3               |   1 +
 librdmacm/man/rdma_create_ep.3             |   1 +
 librdmacm/man/rdma_create_event_channel.3  |   1 +
 librdmacm/man/rdma_create_id.3             |   1 +
 librdmacm/man/rdma_create_qp.3             |   1 +
 librdmacm/man/rdma_create_srq.3            |   1 +
 librdmacm/man/rdma_dereg_mr.3              |   1 +
 librdmacm/man/rdma_destroy_ep.3            |   1 +
 librdmacm/man/rdma_destroy_event_channel.3 |   1 +
 librdmacm/man/rdma_destroy_id.3            |   1 +
 librdmacm/man/rdma_destroy_qp.3            |   1 +
 librdmacm/man/rdma_destroy_srq.3           |   1 +
 librdmacm/man/rdma_disconnect.3            |   1 +
 librdmacm/man/rdma_event_str.3             |   1 +
 librdmacm/man/rdma_free_devices.3          |   1 +
 librdmacm/man/rdma_get_cm_event.3          |   1 +
 librdmacm/man/rdma_get_devices.3           |   1 +
 librdmacm/man/rdma_get_dst_port.3          |   1 +
 librdmacm/man/rdma_get_local_addr.3        |   1 +
 librdmacm/man/rdma_get_peer_addr.3         |   1 +
 librdmacm/man/rdma_get_recv_comp.3         |   1 +
 librdmacm/man/rdma_get_request.3           |   1 +
 librdmacm/man/rdma_get_send_comp.3         |   1 +
 librdmacm/man/rdma_get_src_port.3          |   1 +
 librdmacm/man/rdma_getaddrinfo.3           |   1 +
 librdmacm/man/rdma_join_multicast.3        |   1 +
 librdmacm/man/rdma_leave_multicast.3       |   1 +
 librdmacm/man/rdma_listen.3                |   1 +
 librdmacm/man/rdma_migrate_id.3            |   1 +
 librdmacm/man/rdma_notify.3                |   1 +
 librdmacm/man/rdma_post_read.3             |   1 +
 librdmacm/man/rdma_post_readv.3            |   1 +
 librdmacm/man/rdma_post_recv.3             |   1 +
 librdmacm/man/rdma_post_recvv.3            |   1 +
 librdmacm/man/rdma_post_send.3             |   1 +
 librdmacm/man/rdma_post_sendv.3            |   1 +
 librdmacm/man/rdma_post_ud_send.3          |   1 +
 librdmacm/man/rdma_post_write.3            |   1 +
 librdmacm/man/rdma_post_writev.3           |   1 +
 librdmacm/man/rdma_reg_msgs.3              |   1 +
 librdmacm/man/rdma_reg_read.3              |   1 +
 librdmacm/man/rdma_reg_write.3             |   1 +
 librdmacm/man/rdma_reject.3                |   1 +
 librdmacm/man/rdma_resolve_addr.3          |   1 +
 librdmacm/man/rdma_resolve_route.3         |   1 +
 librdmacm/man/rdma_server.1                |   1 +
 librdmacm/man/rdma_set_option.3            |   1 +
 librdmacm/man/rdma_xclient.1               |   1 +
 librdmacm/man/rdma_xserver.1               |   1 +
 librdmacm/man/riostream.1                  |   1 +
 librdmacm/man/rping.1                      |   1 +
 librdmacm/man/rsocket.7.in                 |   1 +
 librdmacm/man/rstream.1                    |   1 +
 librdmacm/man/ucmatose.1                   |   1 +
 librdmacm/man/udaddy.1                     |   1 +
 64 files changed, 63 insertions(+), 378 deletions(-)
 delete mode 100644 librdmacm/COPYING

diff --git a/librdmacm/COPYING b/librdmacm/COPYING
deleted file mode 100644
index 39f3831585f2..000000000000
diff --git a/librdmacm/docs/rsocket b/librdmacm/docs/rsocket
index f453c1b68089..43834e04b1d3 100644
--- a/librdmacm/docs/rsocket
+++ b/librdmacm/docs/rsocket
@@ -1,3 +1,4 @@
+.. Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 rsocket Protocol and Design Guide               11/11/2012
 
 Data Streaming (TCP) Overview
diff --git a/librdmacm/man/mckey.1 b/librdmacm/man/mckey.1
index 86a51a35e971..a36f57ba9702 100644
--- a/librdmacm/man/mckey.1
+++ b/librdmacm/man/mckey.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "MCKEY" 1 "2007-05-15" "librdmacm" "librdmacm" librdmacm
 .SH NAME
 mckey \- RDMA CM multicast setup and simple data transfer test.
diff --git a/librdmacm/man/rcopy.1 b/librdmacm/man/rcopy.1
index e875458bf162..1dcca494e579 100644
--- a/librdmacm/man/rcopy.1
+++ b/librdmacm/man/rcopy.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RCOPY" 1 "2011-12-2" "librdmacm" "librdmacm" librdmacm
 .SH NAME
 rcopy \- simple file copy over RDMA.
diff --git a/librdmacm/man/rdma_accept.3 b/librdmacm/man/rdma_accept.3
index 0859fac6ef26..a146a8d390af 100644
--- a/librdmacm/man/rdma_accept.3
+++ b/librdmacm/man/rdma_accept.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_ACCEPT" 3 "2014-05-27" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_accept \- Called to accept a connection request.
diff --git a/librdmacm/man/rdma_ack_cm_event.3 b/librdmacm/man/rdma_ack_cm_event.3
index bcf20f719445..a9a616aa0cba 100644
--- a/librdmacm/man/rdma_ack_cm_event.3
+++ b/librdmacm/man/rdma_ack_cm_event.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_ACK_CM_EVENT" 3 "2007-05-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_ack_cm_event \- Free a communication event.
diff --git a/librdmacm/man/rdma_bind_addr.3 b/librdmacm/man/rdma_bind_addr.3
index 8f9bc60e8ed5..37db52c728ca 100644
--- a/librdmacm/man/rdma_bind_addr.3
+++ b/librdmacm/man/rdma_bind_addr.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_BIND_ADDR" 3 "2007-05-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_bind_addr \- Bind an RDMA identifier to a source address.
diff --git a/librdmacm/man/rdma_client.1 b/librdmacm/man/rdma_client.1
index 68bfc7650719..91b2d632251a 100644
--- a/librdmacm/man/rdma_client.1
+++ b/librdmacm/man/rdma_client.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_CLIENT" 1 "2010-07-19" "librdmacm" "librdmacm" librdmacm
 .SH NAME
 rdma_client \- simple RDMA CM connection and ping-pong test.
diff --git a/librdmacm/man/rdma_cm.7 b/librdmacm/man/rdma_cm.7
index 451035bfb588..8e5ad99e6687 100644
--- a/librdmacm/man/rdma_cm.7
+++ b/librdmacm/man/rdma_cm.7
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_CM" 7 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_cm \- RDMA communication manager.
diff --git a/librdmacm/man/rdma_connect.3 b/librdmacm/man/rdma_connect.3
index 51056a06ee6e..ef88e38a75ac 100644
--- a/librdmacm/man/rdma_connect.3
+++ b/librdmacm/man/rdma_connect.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_CONNECT" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_connect \- Initiate an active connection request.
diff --git a/librdmacm/man/rdma_create_ep.3 b/librdmacm/man/rdma_create_ep.3
index cb9b8b647ae5..b1f397625055 100644
--- a/librdmacm/man/rdma_create_ep.3
+++ b/librdmacm/man/rdma_create_ep.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_CREATE_EP" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_create_ep \- Allocate a communication identifier and optional QP.
diff --git a/librdmacm/man/rdma_create_event_channel.3 b/librdmacm/man/rdma_create_event_channel.3
index baa48a6bedf2..928c79701efb 100644
--- a/librdmacm/man/rdma_create_event_channel.3
+++ b/librdmacm/man/rdma_create_event_channel.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_CREATE_EVENT_CHANNEL" 3 "2007-05-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_create_event_channel \- Open a channel used to report communication events.
diff --git a/librdmacm/man/rdma_create_id.3 b/librdmacm/man/rdma_create_id.3
index 81acc9b4b802..0a5093af6678 100644
--- a/librdmacm/man/rdma_create_id.3
+++ b/librdmacm/man/rdma_create_id.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_CREATE_ID" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_create_id \- Allocate a communication identifier.
diff --git a/librdmacm/man/rdma_create_qp.3 b/librdmacm/man/rdma_create_qp.3
index 7e37888df2a2..cd4708f7d4a6 100644
--- a/librdmacm/man/rdma_create_qp.3
+++ b/librdmacm/man/rdma_create_qp.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_CREATE_QP" 3 "2007-05-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_create_qp \- Allocate a QP.
diff --git a/librdmacm/man/rdma_create_srq.3 b/librdmacm/man/rdma_create_srq.3
index 9b917c29eb69..6257e86b3916 100644
--- a/librdmacm/man/rdma_create_srq.3
+++ b/librdmacm/man/rdma_create_srq.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_CREATE_SRQ" 3 "2011-06-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_create_srq \- Allocate a shared receive queue.
diff --git a/librdmacm/man/rdma_dereg_mr.3 b/librdmacm/man/rdma_dereg_mr.3
index 298e886251e3..1fe936b2be50 100644
--- a/librdmacm/man/rdma_dereg_mr.3
+++ b/librdmacm/man/rdma_dereg_mr.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_DEREG_MR" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_dereg_mr \- deregisters a registered memory region.
diff --git a/librdmacm/man/rdma_destroy_ep.3 b/librdmacm/man/rdma_destroy_ep.3
index 750702a01dee..1211f4b55ccf 100644
--- a/librdmacm/man/rdma_destroy_ep.3
+++ b/librdmacm/man/rdma_destroy_ep.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 
 .TH "RDMA_DESTROY_EP" 3 "2011-06-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
diff --git a/librdmacm/man/rdma_destroy_event_channel.3 b/librdmacm/man/rdma_destroy_event_channel.3
index 2c5b8d631a9e..5bc982a7a27f 100644
--- a/librdmacm/man/rdma_destroy_event_channel.3
+++ b/librdmacm/man/rdma_destroy_event_channel.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_DESTROY_EVENT_CHANNEL" 3 "2007-05-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_destroy_event_channel \- Close an event communication channel.
diff --git a/librdmacm/man/rdma_destroy_id.3 b/librdmacm/man/rdma_destroy_id.3
index 0fef7a85562b..1d95ff2d85ab 100644
--- a/librdmacm/man/rdma_destroy_id.3
+++ b/librdmacm/man/rdma_destroy_id.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_DESTROY_ID" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_destroy_id \- Release a communication identifier.
diff --git a/librdmacm/man/rdma_destroy_qp.3 b/librdmacm/man/rdma_destroy_qp.3
index bb1360eb5140..03fba27e35c2 100644
--- a/librdmacm/man/rdma_destroy_qp.3
+++ b/librdmacm/man/rdma_destroy_qp.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_DESTROY_QP" 3 "2007-05-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_destroy_qp \- Deallocate a QP.
diff --git a/librdmacm/man/rdma_destroy_srq.3 b/librdmacm/man/rdma_destroy_srq.3
index 5f0dfe0fc87d..5c633a8dec2c 100644
--- a/librdmacm/man/rdma_destroy_srq.3
+++ b/librdmacm/man/rdma_destroy_srq.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_DESTROY_SRQ" 3 "2011-06-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_destroy_srq \- Deallocate a SRQ.
diff --git a/librdmacm/man/rdma_disconnect.3 b/librdmacm/man/rdma_disconnect.3
index 1890c2885077..23aec9869f09 100644
--- a/librdmacm/man/rdma_disconnect.3
+++ b/librdmacm/man/rdma_disconnect.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_DISCONNECT" 3 "2008-01-02" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_disconnect \- This function disconnects a connection.
diff --git a/librdmacm/man/rdma_event_str.3 b/librdmacm/man/rdma_event_str.3
index abd016df6eca..24c9e165aa3d 100644
--- a/librdmacm/man/rdma_event_str.3
+++ b/librdmacm/man/rdma_event_str.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_EVENT_STR" 3 "2007-05-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_event_str \- Returns a string representation of an rdma cm event.
diff --git a/librdmacm/man/rdma_free_devices.3 b/librdmacm/man/rdma_free_devices.3
index 37b82ef87692..c46bcbfe64d0 100644
--- a/librdmacm/man/rdma_free_devices.3
+++ b/librdmacm/man/rdma_free_devices.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_FREE_DEVICES" 3 "2007-05-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_free_devices \- Frees the list of devices returned by rdma_get_devices.
diff --git a/librdmacm/man/rdma_get_cm_event.3 b/librdmacm/man/rdma_get_cm_event.3
index b0c497021bcc..2623eab8a788 100644
--- a/librdmacm/man/rdma_get_cm_event.3
+++ b/librdmacm/man/rdma_get_cm_event.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_GET_CM_EVENT" 3 "2007-10-31" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_get_cm_event \- Retrieves the next pending communication event.
diff --git a/librdmacm/man/rdma_get_devices.3 b/librdmacm/man/rdma_get_devices.3
index 7f427226c648..be41514e89b7 100644
--- a/librdmacm/man/rdma_get_devices.3
+++ b/librdmacm/man/rdma_get_devices.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_GET_DEVICES" 3 "2007-05-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_get_devices \- Get a list of RDMA devices currently available.
diff --git a/librdmacm/man/rdma_get_dst_port.3 b/librdmacm/man/rdma_get_dst_port.3
index 15677499d111..18637838d184 100644
--- a/librdmacm/man/rdma_get_dst_port.3
+++ b/librdmacm/man/rdma_get_dst_port.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_GET_DST_PORT" 3 "2007-05-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_get_dst_port \- Returns the remote port number of a bound rdma_cm_id.
diff --git a/librdmacm/man/rdma_get_local_addr.3 b/librdmacm/man/rdma_get_local_addr.3
index 25d5312f6a3d..eeaa714204a9 100644
--- a/librdmacm/man/rdma_get_local_addr.3
+++ b/librdmacm/man/rdma_get_local_addr.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_GET_LOCAL_ADDR" 3 "2007-05-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_get_local_addr \- Returns the local IP address of a bound rdma_cm_id.
diff --git a/librdmacm/man/rdma_get_peer_addr.3 b/librdmacm/man/rdma_get_peer_addr.3
index 54f3139dd04b..ff8ce4eab43f 100644
--- a/librdmacm/man/rdma_get_peer_addr.3
+++ b/librdmacm/man/rdma_get_peer_addr.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_GET_PEER_ADDR" 3 "2007-05-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_get_peer_addr \- Returns the remote IP address of a bound rdma_cm_id.
diff --git a/librdmacm/man/rdma_get_recv_comp.3 b/librdmacm/man/rdma_get_recv_comp.3
index dece89ddc9ca..6894e5d96c0c 100644
--- a/librdmacm/man/rdma_get_recv_comp.3
+++ b/librdmacm/man/rdma_get_recv_comp.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_GET_RECV_COMP" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_get_recv_comp \- retrieves a completed receive request.
diff --git a/librdmacm/man/rdma_get_request.3 b/librdmacm/man/rdma_get_request.3
index 93ec70dc90b1..86cb6102d073 100644
--- a/librdmacm/man/rdma_get_request.3
+++ b/librdmacm/man/rdma_get_request.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_GET_REQUEST" 3 "2007-10-31" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_get_request \- Retrieves the next pending connection request event.
diff --git a/librdmacm/man/rdma_get_send_comp.3 b/librdmacm/man/rdma_get_send_comp.3
index f0c92b4cccc1..5085ddb7acea 100644
--- a/librdmacm/man/rdma_get_send_comp.3
+++ b/librdmacm/man/rdma_get_send_comp.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_GET_SEND_COMP" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_get_send_comp \- retrieves a completed send, read, or write request.
diff --git a/librdmacm/man/rdma_get_src_port.3 b/librdmacm/man/rdma_get_src_port.3
index 477ec73663ba..1e36a92cd877 100644
--- a/librdmacm/man/rdma_get_src_port.3
+++ b/librdmacm/man/rdma_get_src_port.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_GET_SRC_PORT" 3 "2007-05-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_get_src_port \- Returns the local port number of a bound rdma_cm_id.
diff --git a/librdmacm/man/rdma_getaddrinfo.3 b/librdmacm/man/rdma_getaddrinfo.3
index 9e133ffea0a5..3ad639360ea0 100644
--- a/librdmacm/man/rdma_getaddrinfo.3
+++ b/librdmacm/man/rdma_getaddrinfo.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_GETADDRINFO" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_getaddrinfo \- Provides transport independent address translation.
diff --git a/librdmacm/man/rdma_join_multicast.3 b/librdmacm/man/rdma_join_multicast.3
index 7886716cb715..4e52e859e8c6 100644
--- a/librdmacm/man/rdma_join_multicast.3
+++ b/librdmacm/man/rdma_join_multicast.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_JOIN_MULTICAST" 3 "2008-01-02" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_join_multicast \- Joins a multicast group.
diff --git a/librdmacm/man/rdma_leave_multicast.3 b/librdmacm/man/rdma_leave_multicast.3
index 802ba57df4ba..9e112d31a553 100644
--- a/librdmacm/man/rdma_leave_multicast.3
+++ b/librdmacm/man/rdma_leave_multicast.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_LEAVE_MULTICAST" 3 "2007-05-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_leave_multicast \- Leaves a multicast group.
diff --git a/librdmacm/man/rdma_listen.3 b/librdmacm/man/rdma_listen.3
index b76d6921e65b..78fd27083664 100644
--- a/librdmacm/man/rdma_listen.3
+++ b/librdmacm/man/rdma_listen.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_LISTEN" 3 "2007-05-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_listen \- Listen for incoming connection requests.
diff --git a/librdmacm/man/rdma_migrate_id.3 b/librdmacm/man/rdma_migrate_id.3
index 8c2d7dd6e40a..f0f7bcee0a59 100644
--- a/librdmacm/man/rdma_migrate_id.3
+++ b/librdmacm/man/rdma_migrate_id.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_MIGRATE_ID" 3 "2007-11-13" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_migrate_id \- Move a communication identifier to a different event channel.
diff --git a/librdmacm/man/rdma_notify.3 b/librdmacm/man/rdma_notify.3
index 62db5756f9d3..c80733a17d71 100644
--- a/librdmacm/man/rdma_notify.3
+++ b/librdmacm/man/rdma_notify.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_NOTIFY" 3 "2007-05-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_notify \- Notifies the librdmacm of an asynchronous event.
diff --git a/librdmacm/man/rdma_post_read.3 b/librdmacm/man/rdma_post_read.3
index d7afc5b15630..11b3e09e16ac 100644
--- a/librdmacm/man/rdma_post_read.3
+++ b/librdmacm/man/rdma_post_read.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_POST_READ" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_post_read \- post an RDMA read work request.
diff --git a/librdmacm/man/rdma_post_readv.3 b/librdmacm/man/rdma_post_readv.3
index cccf2c3e9833..95e415595039 100644
--- a/librdmacm/man/rdma_post_readv.3
+++ b/librdmacm/man/rdma_post_readv.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_POST_READV" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_post_readv \- post an RDMA read work request.
diff --git a/librdmacm/man/rdma_post_recv.3 b/librdmacm/man/rdma_post_recv.3
index 6633cef1350b..5e0530d46899 100644
--- a/librdmacm/man/rdma_post_recv.3
+++ b/librdmacm/man/rdma_post_recv.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_POST_RECV" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_post_recv \- post a work request to receive an incoming message.
diff --git a/librdmacm/man/rdma_post_recvv.3 b/librdmacm/man/rdma_post_recvv.3
index f5e099e1ac42..bd03930c8918 100644
--- a/librdmacm/man/rdma_post_recvv.3
+++ b/librdmacm/man/rdma_post_recvv.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_POST_RECVV" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_post_recvv \- post a work request to receive incoming messages.
diff --git a/librdmacm/man/rdma_post_send.3 b/librdmacm/man/rdma_post_send.3
index 82bcf37ba276..5d0e6d603503 100644
--- a/librdmacm/man/rdma_post_send.3
+++ b/librdmacm/man/rdma_post_send.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_POST_SEND" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_post_send \- post a work request to send a message.
diff --git a/librdmacm/man/rdma_post_sendv.3 b/librdmacm/man/rdma_post_sendv.3
index 1953ce37252b..9b347b1f4746 100644
--- a/librdmacm/man/rdma_post_sendv.3
+++ b/librdmacm/man/rdma_post_sendv.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_POST_SENDV" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_post_sendv \- post a work request to send a message.
diff --git a/librdmacm/man/rdma_post_ud_send.3 b/librdmacm/man/rdma_post_ud_send.3
index f8e2ada87e68..0fcce79e1d33 100644
--- a/librdmacm/man/rdma_post_ud_send.3
+++ b/librdmacm/man/rdma_post_ud_send.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_POST_UD_SEND" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_post_ud_send \- post a work request to send a datagram.
diff --git a/librdmacm/man/rdma_post_write.3 b/librdmacm/man/rdma_post_write.3
index 5ab4fdb5dc4b..62a1e49c37fc 100644
--- a/librdmacm/man/rdma_post_write.3
+++ b/librdmacm/man/rdma_post_write.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_POST_WRITE" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_post_write \- post an RDMA write work request.
diff --git a/librdmacm/man/rdma_post_writev.3 b/librdmacm/man/rdma_post_writev.3
index 1fc7b0a6c709..22ee0fe122b8 100644
--- a/librdmacm/man/rdma_post_writev.3
+++ b/librdmacm/man/rdma_post_writev.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_POST_WRITEV" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_post_writev \- post an RDMA write work request.
diff --git a/librdmacm/man/rdma_reg_msgs.3 b/librdmacm/man/rdma_reg_msgs.3
index 4f5656313734..48c75b309af5 100644
--- a/librdmacm/man/rdma_reg_msgs.3
+++ b/librdmacm/man/rdma_reg_msgs.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_REG_MSGS" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_reg_msgs \- register data buffer(s) for sending or receiving messages.
diff --git a/librdmacm/man/rdma_reg_read.3 b/librdmacm/man/rdma_reg_read.3
index 84417a59ce33..07813e82827e 100644
--- a/librdmacm/man/rdma_reg_read.3
+++ b/librdmacm/man/rdma_reg_read.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_REG_READ" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_reg_read \- register data buffer(s) for remote RDMA read access.
diff --git a/librdmacm/man/rdma_reg_write.3 b/librdmacm/man/rdma_reg_write.3
index cc7beea15f06..2be3cc0cef88 100644
--- a/librdmacm/man/rdma_reg_write.3
+++ b/librdmacm/man/rdma_reg_write.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_REG_WRITE" 3 "2010-07-19" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_reg_write \- register data buffer(s) for remote RDMA write access.
diff --git a/librdmacm/man/rdma_reject.3 b/librdmacm/man/rdma_reject.3
index 268f0b36f8a5..53f038fcccf3 100644
--- a/librdmacm/man/rdma_reject.3
+++ b/librdmacm/man/rdma_reject.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_REJECT" 3 "2007-05-15" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_reject \- Called to reject a connection request.
diff --git a/librdmacm/man/rdma_resolve_addr.3 b/librdmacm/man/rdma_resolve_addr.3
index 3243c7929a36..ce6dcd6a8ae1 100644
--- a/librdmacm/man/rdma_resolve_addr.3
+++ b/librdmacm/man/rdma_resolve_addr.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_RESOLVE_ADDR" 3 "2007-10-31" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_resolve_addr \- Resolve destination and optional source addresses.
diff --git a/librdmacm/man/rdma_resolve_route.3 b/librdmacm/man/rdma_resolve_route.3
index c52f1b3f4347..114f666dcf63 100644
--- a/librdmacm/man/rdma_resolve_route.3
+++ b/librdmacm/man/rdma_resolve_route.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_RESOLVE_ROUTE" 3 "2007-10-31" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_resolve_route \- Resolve the route information needed to establish a connection.
diff --git a/librdmacm/man/rdma_server.1 b/librdmacm/man/rdma_server.1
index 19f4860e4da3..ada2564983f3 100644
--- a/librdmacm/man/rdma_server.1
+++ b/librdmacm/man/rdma_server.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_SERVER" 1 "2010-07-19" "librdmacm" "librdmacm" librdmacm
 .SH NAME
 rdma_server \- simple RDMA CM connection and ping-pong test.
diff --git a/librdmacm/man/rdma_set_option.3 b/librdmacm/man/rdma_set_option.3
index 74bf5ceba88d..93a60476f18f 100644
--- a/librdmacm/man/rdma_set_option.3
+++ b/librdmacm/man/rdma_set_option.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_SET_OPTION" 3 "2007-08-06" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rdma_set_option \- Set communication options for an rdma_cm_id.
diff --git a/librdmacm/man/rdma_xclient.1 b/librdmacm/man/rdma_xclient.1
index b4bb04560d23..d874c6e91e73 100644
--- a/librdmacm/man/rdma_xclient.1
+++ b/librdmacm/man/rdma_xclient.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_XCLIENT" 1 "2011-06-15" "librdmacm" "librdmacm" librdmacm
 .SH NAME
 rdma_xclient \- RDMA CM communication client test program
diff --git a/librdmacm/man/rdma_xserver.1 b/librdmacm/man/rdma_xserver.1
index a26c96239389..4c12e2563319 100644
--- a/librdmacm/man/rdma_xserver.1
+++ b/librdmacm/man/rdma_xserver.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RDMA_XSERVER" 1 "2011-06-15" "librdmacm" "librdmacm" librdmacm
 .SH NAME
 rdma_xserver \- RDMA CM communication server test program
diff --git a/librdmacm/man/riostream.1 b/librdmacm/man/riostream.1
index 14e77fa0f822..537302b60b12 100644
--- a/librdmacm/man/riostream.1
+++ b/librdmacm/man/riostream.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RIOSTREAM" 1 "2012-10-24" "librdmacm" "librdmacm" librdmacm
 .SH NAME
 riostream \- zero-copy streaming over RDMA ping-pong test.
diff --git a/librdmacm/man/rping.1 b/librdmacm/man/rping.1
index 127d290d0cfd..fc3aa7b889a5 100644
--- a/librdmacm/man/rping.1
+++ b/librdmacm/man/rping.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RPING" 1 "2007-05-15" "librdmacm" "librdmacm" librdmacm
 .SH NAME
 rping \- RDMA CM connection and RDMA ping-pong test.
diff --git a/librdmacm/man/rsocket.7.in b/librdmacm/man/rsocket.7.in
index 6adf156f4062..5b7776900262 100644
--- a/librdmacm/man/rsocket.7.in
+++ b/librdmacm/man/rsocket.7.in
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RSOCKET" 7 "2013-01-21" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
 rsocket \- RDMA socket API
diff --git a/librdmacm/man/rstream.1 b/librdmacm/man/rstream.1
index f53679fd9f1a..7b1c25b2a2fc 100644
--- a/librdmacm/man/rstream.1
+++ b/librdmacm/man/rstream.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "RSTREAM" 1 "2011-11-16" "librdmacm" "librdmacm" librdmacm
 .SH NAME
 rstream \- streaming over RDMA ping-pong test.
diff --git a/librdmacm/man/ucmatose.1 b/librdmacm/man/ucmatose.1
index 57e2c1b23bd9..56e0702989ae 100644
--- a/librdmacm/man/ucmatose.1
+++ b/librdmacm/man/ucmatose.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "UCMATOSE" 1 "2007-05-15" "librdmacm" "librdmacm" librdmacm
 .SH NAME
 ucmatose \- RDMA CM connection and simple ping-pong test.
diff --git a/librdmacm/man/udaddy.1 b/librdmacm/man/udaddy.1
index 022018ec9449..bc84504347bd 100644
--- a/librdmacm/man/udaddy.1
+++ b/librdmacm/man/udaddy.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "UDADDY" 1 "2007-05-15" "librdmacm" "librdmacm" librdmacm
 .SH NAME
 udaddy \- RDMA CM datagram setup and simple ping-pong test.
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
