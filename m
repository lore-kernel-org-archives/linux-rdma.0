From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH librdmacm] man/rstream.1: Update man page to be consistent
 with rstream -h
Date: Wed, 11 Sep 2013 15:37:11 -0400
Message-ID: <5230C667.1060900@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/man/rstream.1 b/man/rstream.1
index 29aa66b..f53679f 100644
--- a/man/rstream.1
+++ b/man/rstream.1
@@ -4,8 +4,8 @@ rstream \- streaming over RDMA ping-pong test.
 .SH SYNOPSIS
 .sp
 .nf
-\fIrstream\fR [-s server_address] [-b bind_address] [-B buffer_size]
-			[-I iterations] [-C transfer_count]
+\fIrstream\fR [-s server_address] [-b bind_address] [-f address_format]
+			[-B buffer_size] [-I iterations] [-C transfer_count]
 			[-S transfer_size] [-p server_port] [-T test_option]
 .fi
 .SH "DESCRIPTION"
@@ -21,6 +21,9 @@ This option must be specified by the client.
 \-b bind_address
 The local network address to bind to.
 .TP
+\-f address_format
+Supported address formats are ip, ipv6, gid, or name.
+.TP
 \-B buffer_size
 Indicates the size of the send and receive network buffers.
 .TP
@@ -52,6 +55,8 @@ f | fork - fork server processing (forces -T s option)
 .P
 n | nonblocking - uses non-blocking calls
 .P
+r | resolve - use rdma cm to resolve address
+.P
 v | verify - verifies data transfers
 .SH "NOTES"
 Basic usage is to start rstream on a server system, then run
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
