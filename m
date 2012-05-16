From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/4] librdmacm/rstream: Always set TCP_NODELAY on rsocket
Date: Wed, 16 May 2012 23:07:42 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A22CD7@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The NODELAY option is coupled with whether the socket is blocking
or nonblocking.  Remove this coupling and always set the NODELAY
option.

NODELAY currently has no effect on rsockets.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 examples/rstream.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/examples/rstream.c b/examples/rstream.c
index 8aa089d..a313fdb 100644
--- a/examples/rstream.c
+++ b/examples/rstream.c
@@ -57,7 +57,6 @@ static int use_rs = 1;
 static int use_async;
 static int verify;
 static int flags;
-static int no_delay;
 static int custom;
 static int iterations = 1;
 static int transfer_size = 1000;
@@ -151,7 +150,6 @@ static void init_latency_test(int size)
 {
 	size_str(test_name, size);
 	sprintf(test_name, "%s_lat", test_name);
-	no_delay = 1;
 	flags |= MSG_DONTWAIT;
 	transfer_count = 1;
 	transfer_size = size;
@@ -162,7 +160,6 @@ static void init_bandwidth_test(int size)
 {
 	size_str(test_name, size);
 	sprintf(test_name, "%s_bw", test_name);
-	no_delay = 1;
 	flags |= MSG_DONTWAIT;
 	iterations = 1;
 	transfer_size = size;
@@ -328,10 +325,8 @@ static void set_options(int rs)
 			break;
 	}
 
-	if (no_delay) {
-		rs_setsockopt(rs, IPPROTO_TCP, TCP_NODELAY,
-			      (void *) &no_delay, sizeof(no_delay));
-	}
+	val = 1;
+	rs_setsockopt(rs, IPPROTO_TCP, TCP_NODELAY, (void *) &val, sizeof(val));
 
 	if (flags & MSG_DONTWAIT) {
 		rs_fcntl(rs, F_SETFL, O_NONBLOCK);
@@ -492,7 +487,6 @@ static int set_test_opt(char *optarg)
 			break;
 		case 'n':
 			flags |= MSG_DONTWAIT;
-			no_delay = 1;
 			break;
 		case 'v':
 			verify = 1;
@@ -507,7 +501,6 @@ static int set_test_opt(char *optarg)
 			use_async = 1;
 		} else if (!strncasecmp("nonblock", optarg, 8)) {
 			flags |= MSG_DONTWAIT;
-			no_delay = 1;
 		} else if (!strncasecmp("verify", optarg, 6)) {
 			verify = 1;
 		} else {


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
