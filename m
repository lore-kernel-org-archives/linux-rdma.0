From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 14/16] librdmacm/rstream: Add option to specify size of
 send/recv buffers
Date: Wed, 30 May 2012 17:21:45 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A24C2B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 examples/rstream.c |   34 +++++++++++++---------------------
 man/rstream.1      |    5 ++++-
 2 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/examples/rstream.c b/examples/rstream.c
index c440f04..df36e34 100644
--- a/examples/rstream.c
+++ b/examples/rstream.c
@@ -81,6 +81,7 @@ static int size_option;
 static int iterations = 1;
 static int transfer_size = 1000;
 static int transfer_count = 1000;
+static int buffer_size;
 static char test_name[9] = "custom";
 static char *port = "7471";
 static char *dst_addr;
@@ -349,33 +350,20 @@ out:
 
 static void set_options(int rs)
 {
-	int val, optname, ret;
-	long long bytes;
-	socklen_t size;
+	int val;
 
-	bytes = transfer_size * transfer_count * iterations;
-	for (optname = SO_SNDBUF; ; optname = SO_RCVBUF) {
-		size = sizeof val;
-		ret = rs_getsockopt(rs, SOL_SOCKET, optname, (void *) &val, &size);
-		if (ret)
-			break;
-
-		if (val < bytes) {
-			size = sizeof val;
-			val = ((val << 2) > bytes) ? bytes : (val << 2);
-			rs_setsockopt(rs, SOL_SOCKET, optname, (void *) &val, size);
-		}
-
-		if (optname == SO_RCVBUF)
-			break;
+	if (buffer_size) {
+		rs_setsockopt(rs, SOL_SOCKET, SO_SNDBUF, (void *) &buffer_size,
+			      sizeof buffer_size);
+		rs_setsockopt(rs, SOL_SOCKET, SO_RCVBUF, (void *) &buffer_size,
+			      sizeof buffer_size);
 	}
 
 	val = 1;
 	rs_setsockopt(rs, IPPROTO_TCP, TCP_NODELAY, (void *) &val, sizeof(val));
 
-	if (flags & MSG_DONTWAIT) {
+	if (flags & MSG_DONTWAIT)
 		rs_fcntl(rs, F_SETFL, O_NONBLOCK);
-	}
 }
 
 static int server_connect(void)
@@ -586,7 +574,7 @@ int main(int argc, char **argv)
 {
 	int op, ret;
 
-	while ((op = getopt(argc, argv, "s:b:I:C:S:p:T:")) != -1) {
+	while ((op = getopt(argc, argv, "s:b:B:I:C:S:p:T:")) != -1) {
 		switch (op) {
 		case 's':
 			dst_addr = optarg;
@@ -594,6 +582,9 @@ int main(int argc, char **argv)
 		case 'b':
 			src_addr = optarg;
 			break;
+		case 'B':
+			buffer_size = atoi(optarg);
+			break;
 		case 'I':
 			custom = 1;
 			iterations = atoi(optarg);
@@ -621,6 +612,7 @@ int main(int argc, char **argv)
 			printf("usage: %s\n", argv[0]);
 			printf("\t[-s server_address]\n");
 			printf("\t[-b bind_address]\n");
+			printf("\t[-B buffer_size]\n");
 			printf("\t[-I iterations]\n");
 			printf("\t[-C transfer_count]\n");
 			printf("\t[-S transfer_size or all]\n");
diff --git a/man/rstream.1 b/man/rstream.1
index 0909932..ea87b95 100644
--- a/man/rstream.1
+++ b/man/rstream.1
@@ -4,7 +4,7 @@ rstream \- streaming over RDMA ping-pong test.
 .SH SYNOPSIS
 .sp
 .nf
-\fIrstream\fR [-s server_address] [-b bind_address]
+\fIrstream\fR [-s server_address] [-b bind_address] [-B buffer_size]
 			[-I iterations] [-C transfer_count]
 			[-S transfer_size] [-p server_port] [-T test_option]
 .fi
@@ -21,6 +21,9 @@ This option must be specified by the client.
 \-b bind_address
 The local network address to bind to.
 .TP
+\-B buffer_size
+Indicates the size of the send and receive network buffers.
+.TP
 \-I iterations
 The number of times that the specified number of messages will be
 exchanged between the client and server.  (default 1000)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
