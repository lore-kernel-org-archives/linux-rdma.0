From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/4] librdmacm/rstream: Set rsocket nonblocking for base
 tests
Date: Wed, 16 May 2012 23:07:42 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A22CDD@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The base set of rstream tests want nonblocking rsockets, but don't
actually set the rsocket to nonblocking.  It instead relies on the
MSG_DONTWAIT flag.  Make the code match the expected behavior and
set the rsocket to nonblocking and make nonblocking the default.

Provide a test option to switch it back to blocking mode.  We keep
the existing nonblocking test option for compatibility.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 examples/rstream.c |   10 +++++++---
 man/rstream.1      |    2 ++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/examples/rstream.c b/examples/rstream.c
index a313fdb..a214b1a 100644
--- a/examples/rstream.c
+++ b/examples/rstream.c
@@ -56,7 +56,7 @@ static int test_size[] = {
 static int use_rs = 1;
 static int use_async;
 static int verify;
-static int flags;
+static int flags = MSG_DONTWAIT;
 static int custom;
 static int iterations = 1;
 static int transfer_size = 1000;
@@ -150,7 +150,6 @@ static void init_latency_test(int size)
 {
 	size_str(test_name, size);
 	sprintf(test_name, "%s_lat", test_name);
-	flags |= MSG_DONTWAIT;
 	transfer_count = 1;
 	transfer_size = size;
 	iterations = size_to_count(transfer_size);
@@ -160,7 +159,6 @@ static void init_bandwidth_test(int size)
 {
 	size_str(test_name, size);
 	sprintf(test_name, "%s_bw", test_name);
-	flags |= MSG_DONTWAIT;
 	iterations = 1;
 	transfer_size = size;
 	transfer_count = size_to_count(transfer_size);
@@ -485,6 +483,9 @@ static int set_test_opt(char *optarg)
 		case 'a':
 			use_async = 1;
 			break;
+		case 'b':
+			flags &= ~MSG_DONTWAIT;
+			break;
 		case 'n':
 			flags |= MSG_DONTWAIT;
 			break;
@@ -499,6 +500,8 @@ static int set_test_opt(char *optarg)
 			use_rs = 0;
 		} else if (!strncasecmp("async", optarg, 5)) {
 			use_async = 1;
+		} else if (!strncasecmp("block", optarg, 5)) {
+			flags &= ~MSG_DONTWAIT;
 		} else if (!strncasecmp("nonblock", optarg, 8)) {
 			flags |= MSG_DONTWAIT;
 		} else if (!strncasecmp("verify", optarg, 6)) {
@@ -552,6 +555,7 @@ int main(int argc, char **argv)
 			printf("\t[-T test_option]\n");
 			printf("\t    s|sockets - use standard tcp/ip sockets\n");
 			printf("\t    a|async - asynchronous operation\n");
+			printf("\t    b|blocking - use blocking calls\n");
 			printf("\t    n|nonblocking - use nonblocking calls\n");
 			printf("\t    v|verify - verify data\n");
 			exit(1);
diff --git a/man/rstream.1 b/man/rstream.1
index 701db3a..58bd7e3 100644
--- a/man/rstream.1
+++ b/man/rstream.1
@@ -42,6 +42,8 @@ s | socket  - uses standard socket calls to transfer data
 .P
 a | async - uses asynchronous operation (e.g. select / poll)
 .P
+b | blocking - uses blocking calls
+.P
 n | nonblocking - uses non-blocking calls
 .P
 v | verify - verifies data transfers


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
