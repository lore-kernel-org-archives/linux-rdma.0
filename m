From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH librdmacm 5/5] rstream: Use rsocket option to set route directly
Date: Fri,  2 Aug 2013 15:20:22 -0700
Message-ID: <1375482022-5953-6-git-send-email-sean.hefty@intel.com>
References: <1375482022-5953-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375482022-5953-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If we're using GID addressing, rdma_getaddrinfo can return
routing data directly.  Add an option for the user to
indicate that rdma_getaddrinfo should be called in place of
getaddrinfo.  And if routing data is available, call
rsetsockopt to set the route.

This helps test rsockets when ibacm and AF_IB support are
available.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 examples/rstream.c |   53 ++++++++++++++++++++++++++++++++-------------------
 1 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/examples/rstream.c b/examples/rstream.c
index e27ddcd..278437f 100644
--- a/examples/rstream.c
+++ b/examples/rstream.c
@@ -75,6 +75,7 @@ static struct test_size_param test_size[] = {
 
 static int rs, lrs;
 static int use_async;
+static int use_rgai;
 static int verify;
 static int flags = MSG_DONTWAIT;
 static int poll_timeout = 0;
@@ -287,11 +288,11 @@ static void set_options(int rs)
 
 static int server_listen(void)
 {
-	struct rdma_addrinfo *rai;
+	struct rdma_addrinfo *rai = NULL;
 	struct addrinfo *ai;
 	int val, ret;
 
-	if (rai_hints.ai_flags) {
+	if (use_rgai) {
 		rai_hints.ai_flags |= RAI_PASSIVE;
 		ret = rdma_getaddrinfo(src_addr, port, &rai_hints, &rai);
 	} else {
@@ -303,9 +304,8 @@ static int server_listen(void)
 		return ret;
 	}
 
-	lrs = rai_hints.ai_flags ?
-	      rs_socket(rai->ai_family, SOCK_STREAM, 0) :
-	      rs_socket(ai->ai_family, SOCK_STREAM, 0);
+	lrs = rai ? rs_socket(rai->ai_family, SOCK_STREAM, 0) :
+		    rs_socket(ai->ai_family, SOCK_STREAM, 0);
 	if (lrs < 0) {
 		perror("rsocket");
 		ret = lrs;
@@ -319,9 +319,8 @@ static int server_listen(void)
 		goto close;
 	}
 
-	ret = rai_hints.ai_flags ?
-	      rs_bind(lrs, rai->ai_src_addr, rai->ai_src_len) :
-	      rs_bind(lrs, ai->ai_addr, ai->ai_addrlen);
+	ret = rai ? rs_bind(lrs, rai->ai_src_addr, rai->ai_src_len) :
+		    rs_bind(lrs, ai->ai_addr, ai->ai_addrlen);
 	if (ret) {
 		perror("rbind");
 		goto close;
@@ -335,7 +334,7 @@ close:
 	if (ret)
 		rs_close(lrs);
 free:
-	if (rai_hints.ai_flags)
+	if (rai)
 		rdma_freeaddrinfo(rai);
 	else
 		freeaddrinfo(ai);
@@ -376,23 +375,22 @@ static int server_connect(void)
 
 static int client_connect(void)
 {
-	struct rdma_addrinfo *rai;
+	struct rdma_addrinfo *rai = NULL;
 	struct addrinfo *ai;
 	struct pollfd fds;
 	int ret, err;
 	socklen_t len;
 
- 	ret = rai_hints.ai_flags ?
- 	      rdma_getaddrinfo(dst_addr, port, &rai_hints, &rai) :
- 	      getaddrinfo(dst_addr, port, &ai_hints, &ai);
+	ret = use_rgai ? rdma_getaddrinfo(dst_addr, port, &rai_hints, &rai) :
+			 getaddrinfo(dst_addr, port, &ai_hints, &ai);
+
 	if (ret) {
 		perror("getaddrinfo");
 		return ret;
 	}
 
-	rs = rai_hints.ai_flags ?
-	     rs_socket(rai->ai_family, SOCK_STREAM, 0) :
-	     rs_socket(ai->ai_family, SOCK_STREAM, 0);
+	rs = rai ? rs_socket(rai->ai_family, SOCK_STREAM, 0) :
+		   rs_socket(ai->ai_family, SOCK_STREAM, 0);
 	if (rs < 0) {
 		perror("rsocket");
 		ret = rs;
@@ -402,9 +400,17 @@ static int client_connect(void)
 	set_options(rs);
 	/* TODO: bind client to src_addr */
 
-	ret = rai_hints.ai_flags ?
-	      rs_connect(rs, rai->ai_dst_addr, rai->ai_dst_len) :
-	      rs_connect(rs, ai->ai_addr, ai->ai_addrlen);
+	if (rai && rai->ai_route) {
+		ret = rs_setsockopt(rs, SOL_RDMA, RDMA_ROUTE, rai->ai_route,
+				    rai->ai_route_len);
+		if (ret) {
+			perror("rsetsockopt RDMA_ROUTE");
+			goto close;
+		}
+	}
+
+	ret = rai ? rs_connect(rs, rai->ai_dst_addr, rai->ai_dst_len) :
+		    rs_connect(rs, ai->ai_addr, ai->ai_addrlen);
 	if (ret && (errno != EINPROGRESS)) {
 		perror("rconnect");
 		goto close;
@@ -432,7 +438,7 @@ close:
 	if (ret)
 		rs_close(rs);
 free:
-	if (rai_hints.ai_flags)
+	if (rai)
 		rdma_freeaddrinfo(rai);
 	else
 		freeaddrinfo(ai);
@@ -527,6 +533,9 @@ static int set_test_opt(char *optarg)
 		case 'n':
 			flags |= MSG_DONTWAIT;
 			break;
+		case 'r':
+			use_rgai = 1;
+			break;
 		case 'v':
 			verify = 1;
 			break;
@@ -542,6 +551,8 @@ static int set_test_opt(char *optarg)
 			flags = (flags & ~MSG_DONTWAIT) | MSG_WAITALL;
 		} else if (!strncasecmp("nonblock", optarg, 8)) {
 			flags |= MSG_DONTWAIT;
+		} else if (strncasecmp("resolve", optarg, 7)) {
+			use_rgai = 1;
 		} else if (!strncasecmp("verify", optarg, 6)) {
 			verify = 1;
 		} else if (!strncasecmp("fork", optarg, 4)) {
@@ -574,6 +585,7 @@ int main(int argc, char **argv)
 			} else if (!strncasecmp("gid", optarg, 3)) {
 				rai_hints.ai_flags = RAI_NUMERICHOST | RAI_FAMILY;
 				rai_hints.ai_family = AF_IB;
+				use_rgai = 1;
 			}
 			break;
 		case 'B':
@@ -619,6 +631,7 @@ int main(int argc, char **argv)
 			printf("\t    b|blocking - use blocking calls\n");
 			printf("\t    f|fork - fork server processing\n");
 			printf("\t    n|nonblocking - use nonblocking calls\n");
+			printf("\t    r|resolve - use rdma cm to resolve address\n");
 			printf("\t    v|verify - verify data\n");
 			exit(1);
 		}
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
