From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/4] librdmacm/rstream: Set rsocket nonblocking if set to
 async operation
Date: Wed, 16 May 2012 23:07:42 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A22CE3@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If asynchronous use is specified (use of poll/select), set the
rsocket to nonblocking.  This matches the common usage case for
asynchronous sockets.

When asynchronous support is enabled, the nonblocking/blocking
test option determines whether the poll/select call will block,
or if rstream will spin on the calls.

This provides more flexibility with how the rsocket is used.
Specifically, MPI often uses nonblocking sockets, but spins on
poll/select.  However, many apps will use nonblocking sockets,
but wait on poll/select.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 examples/rstream.c |   40 +++++++++++++++++++++++++++++-----------
 1 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/examples/rstream.c b/examples/rstream.c
index b73d59a..2b25ef5 100644
--- a/examples/rstream.c
+++ b/examples/rstream.c
@@ -57,6 +57,7 @@ static int use_rs = 1;
 static int use_async;
 static int verify;
 static int flags = MSG_DONTWAIT;
+static int poll_timeout = 0;
 static int custom;
 static int iterations = 1;
 static int transfer_size = 1000;
@@ -190,6 +191,17 @@ static int verify_buf(void *buf, int size)
 	return 0;
 }
 
+static int do_poll(struct pollfd *fds)
+{
+	int ret;
+
+	do {
+		ret = rs_poll(fds, 1, poll_timeout);
+	} while (!ret);
+
+	return ret == 1 ? 0 : ret;
+}
+
 static int send_xfer(int rs, int size)
 {
 	struct pollfd fds;
@@ -205,8 +217,8 @@ static int send_xfer(int rs, int size)
 
 	for (offset = 0; offset < size; ) {
 		if (use_async) {
-			ret = rs_poll(&fds, 1, -1);
-			if (ret != 1)
+			ret = do_poll(&fds);
+			if (ret)
 				return ret;
 		}
 
@@ -234,8 +246,8 @@ static int recv_xfer(int rs, int size)
 
 	for (offset = 0; offset < size; ) {
 		if (use_async) {
-			ret = rs_poll(&fds, 1, -1);
-			if (ret != 1)
+			ret = do_poll(&fds);
+			if (ret)
 				return ret;
 		}
 
@@ -377,8 +389,8 @@ static int server_connect(void)
 			fds.fd = lrs;
 			fds.events = POLLIN;
 
-			ret = rs_poll(&fds, 1, -1);
-			if (ret != 1) {
+			ret = do_poll(&fds);
+			if (ret) {
 				perror("rpoll");
 				goto close;
 			}
@@ -421,21 +433,24 @@ static int client_connect(void)
 	ret = rs_connect(rs, res->ai_addr, res->ai_addrlen);
 	if (ret && (errno != EINPROGRESS)) {
 		perror("rconnect");
-		rs_close(rs);
-		rs = ret;
+		goto err;
 	}
 
 	if (errno == EINPROGRESS) {
 		fds.fd = rs;
 		fds.events = POLLOUT;
-		do {
-			ret = rs_poll(&fds, 1, -1);
-		} while (!ret);
+		ret = do_poll(&fds);
+		if (ret)
+			goto err;
 	}
 
 free:
 	freeaddrinfo(res);
 	return rs;
+err:
+	freeaddrinfo(res);
+	rs_close(rs);
+	return ret;
 }
 
 static int run(void)
@@ -562,6 +577,9 @@ int main(int argc, char **argv)
 		}
 	}
 
+	if (!(flags & MSG_DONTWAIT))
+		poll_timeout = -1;
+
 	ret = run();
 	return ret;
 }


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
