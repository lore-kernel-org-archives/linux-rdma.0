From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] librdmacm: Store error code from getaddrinfo in errno
Date: Tue,  7 Nov 2017 11:50:38 +0200
Message-ID: <20171107095038.7348-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A return value of -1 from rdma_getaddrinfo can indicates either
EAI_BADFLAGS returned from getaddrinfo or a generic error returned by
rdma_getaddrinfo itself.

Fix this conflict by sticking to the existing convention where -1
indicates an error while the actual underling error code is stored in
errno.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 librdmacm/addrinfo.c              | 2 +-
 librdmacm/examples/cmatose.c      | 4 ++--
 librdmacm/examples/cmtime.c       | 4 ++--
 librdmacm/examples/rdma_client.c  | 2 +-
 librdmacm/examples/rdma_server.c  | 2 +-
 librdmacm/examples/rdma_xclient.c | 2 +-
 librdmacm/examples/rdma_xserver.c | 2 +-
 librdmacm/examples/riostream.c    | 5 ++++-
 librdmacm/examples/rstream.c      | 9 ++++++---
 librdmacm/examples/udaddy.c       | 4 ++--
 10 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/librdmacm/addrinfo.c b/librdmacm/addrinfo.c
index 7e660659..b5f45f69 100644
--- a/librdmacm/addrinfo.c
+++ b/librdmacm/addrinfo.c
@@ -227,7 +227,7 @@ static int ucma_getaddrinfo(const char *node, const char *service,
 		ret = getaddrinfo(node, service, NULL, &ai);
 	}
 	if (ret)
-		return ret;
+		return ERR(ret);
 
 	ret = ucma_convert_to_rai(rai, hints, ai);
 	freeaddrinfo(ai);
diff --git a/librdmacm/examples/cmatose.c b/librdmacm/examples/cmatose.c
index b1c9dd13..625849ce 100644
--- a/librdmacm/examples/cmatose.c
+++ b/librdmacm/examples/cmatose.c
@@ -507,7 +507,7 @@ static int run_server(void)
 
 	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &test.rai);
 	if (ret) {
-		printf("cmatose: getrdmaaddr error: %s\n", gai_strerror(ret));
+		printf("cmatose: getrdmaaddr error: %s\n", gai_strerror(errno));
 		goto out;
 	}
 
@@ -580,7 +580,7 @@ static int run_client(void)
 
 	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &test.rai);
 	if (ret) {
-		printf("cmatose: getaddrinfo error: %s\n", gai_strerror(ret));
+		printf("cmatose: getaddrinfo error: %s\n", gai_strerror(errno));
 		return ret;
 	}
 
diff --git a/librdmacm/examples/cmtime.c b/librdmacm/examples/cmtime.c
index aa96b901..dc881701 100644
--- a/librdmacm/examples/cmtime.c
+++ b/librdmacm/examples/cmtime.c
@@ -462,7 +462,7 @@ static int run_server(void)
 
 	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &rai);
 	if (ret) {
-		printf("getrdmaaddr error: %s\n", gai_strerror(ret));
+		printf("getrdmaaddr error: %s\n", gai_strerror(errno));
 		goto out;
 	}
 
@@ -491,7 +491,7 @@ static int run_client(void)
 
 	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &rai);
 	if (ret) {
-		printf("getaddrinfo error: %s\n", gai_strerror(ret));
+		printf("getaddrinfo error: %s\n", gai_strerror(errno));
 		return ret;
 	}
 
diff --git a/librdmacm/examples/rdma_client.c b/librdmacm/examples/rdma_client.c
index c27047c5..0bfd9323 100644
--- a/librdmacm/examples/rdma_client.c
+++ b/librdmacm/examples/rdma_client.c
@@ -56,7 +56,7 @@ static int run(void)
 	hints.ai_port_space = RDMA_PS_TCP;
 	ret = rdma_getaddrinfo(server, port, &hints, &res);
 	if (ret) {
-		printf("rdma_getaddrinfo: %s\n", gai_strerror(ret));
+		printf("rdma_getaddrinfo: %s\n", gai_strerror(errno));
 		goto out;
 	}
 
diff --git a/librdmacm/examples/rdma_server.c b/librdmacm/examples/rdma_server.c
index bcf649fe..89feaa64 100644
--- a/librdmacm/examples/rdma_server.c
+++ b/librdmacm/examples/rdma_server.c
@@ -57,7 +57,7 @@ static int run(void)
 	hints.ai_port_space = RDMA_PS_TCP;
 	ret = rdma_getaddrinfo(NULL, port, &hints, &res);
 	if (ret) {
-		printf("rdma_getaddrinfo: %s\n", gai_strerror(ret));
+		printf("rdma_getaddrinfo: %s\n", gai_strerror(errno));
 		return ret;
 	}
 
diff --git a/librdmacm/examples/rdma_xclient.c b/librdmacm/examples/rdma_xclient.c
index 63dfb6df..0466c1a6 100644
--- a/librdmacm/examples/rdma_xclient.c
+++ b/librdmacm/examples/rdma_xclient.c
@@ -82,7 +82,7 @@ static int test(void)
 
 	ret = rdma_getaddrinfo(server, port, &hints, &res);
 	if (ret) {
-		printf("rdma_getaddrinfo: %s\n", gai_strerror(ret));
+		printf("rdma_getaddrinfo: %s\n", gai_strerror(errno));
 		return ret;
 	}
 
diff --git a/librdmacm/examples/rdma_xserver.c b/librdmacm/examples/rdma_xserver.c
index 8d8ac314..6cc00927 100644
--- a/librdmacm/examples/rdma_xserver.c
+++ b/librdmacm/examples/rdma_xserver.c
@@ -79,7 +79,7 @@ static int test(void)
 
 	ret = rdma_getaddrinfo(NULL, port, &hints, &res);
 	if (ret) {
-		printf("rdma_getaddrinfo: %s\n", gai_strerror(ret));
+		printf("rdma_getaddrinfo: %s\n", gai_strerror(errno));
 		return ret;
 	}
 
diff --git a/librdmacm/examples/riostream.c b/librdmacm/examples/riostream.c
index bdf4fd34..872cfcdc 100644
--- a/librdmacm/examples/riostream.c
+++ b/librdmacm/examples/riostream.c
@@ -358,6 +358,8 @@ static int server_listen(void)
 	if (use_rgai) {
 		rai_hints.ai_flags |= RAI_PASSIVE;
 		ret = rdma_getaddrinfo(src_addr, port, &rai_hints, &rai);
+		if (ret == -1)
+			ret = errno;
 	} else {
 		ai_hints.ai_flags |= AI_PASSIVE;
 		ret = getaddrinfo(src_addr, port, &ai_hints, &ai);
@@ -444,7 +446,8 @@ static int client_connect(void)
 	ret = use_rgai ? rdma_getaddrinfo(dst_addr, port, &rai_hints, &rai) :
 			 getaddrinfo(dst_addr, port, &ai_hints, &ai);
 	if (ret) {
-		printf("getaddrinfo: %s\n", gai_strerror(ret));
+		printf("getaddrinfo: %s\n", gai_strerror(use_rgai ? errno :
+							 ret));
 		return ret;
 	}
 
diff --git a/librdmacm/examples/rstream.c b/librdmacm/examples/rstream.c
index 7523269c..c1d7bb49 100644
--- a/librdmacm/examples/rstream.c
+++ b/librdmacm/examples/rstream.c
@@ -327,7 +327,8 @@ static int server_listen(void)
 		ret = getaddrinfo(src_addr, port, &ai_hints, &ai);
 	}
 	if (ret) {
-		printf("getaddrinfo: %s\n", gai_strerror(ret));
+		printf("getaddrinfo: %s\n", gai_strerror(use_rgai ? errno :
+							 ret));
 		return ret;
 	}
 
@@ -412,7 +413,8 @@ static int client_connect(void)
 			 getaddrinfo(dst_addr, port, &ai_hints, &ai);
 
 	if (ret) {
-		printf("getaddrinfo: %s\n", gai_strerror(ret));
+		printf("getaddrinfo: %s\n", gai_strerror(use_rgai ? errno :
+							 ret));
 		return ret;
 	}
 
@@ -425,7 +427,8 @@ static int client_connect(void)
 			ret = getaddrinfo(src_addr, port, &ai_hints, &ai_src);
 		}
 		if (ret) {
-			printf("getaddrinfo src_addr: %s\n", gai_strerror(ret));
+			printf("getaddrinfo src_addr: %s\n",
+			       gai_strerror(use_rgai ? errno : ret));
 			return ret;
 		}
 	}
diff --git a/librdmacm/examples/udaddy.c b/librdmacm/examples/udaddy.c
index b1ac90c3..fae3d09c 100644
--- a/librdmacm/examples/udaddy.c
+++ b/librdmacm/examples/udaddy.c
@@ -514,7 +514,7 @@ static int run_server(void)
 
 	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &test.rai);
 	if (ret) {
-		printf("udaddy: getrdmaaddr error: %s\n", gai_strerror(ret));
+		printf("udaddy: getrdmaaddr error: %s\n", gai_strerror(errno));
 		goto out;
 	}
 
@@ -563,7 +563,7 @@ static int run_client(void)
 
 	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &test.rai);
 	if (ret) {
-		printf("udaddy: getaddrinfo error: %s\n", gai_strerror(ret));
+		printf("udaddy: getaddrinfo error: %s\n", gai_strerror(errno));
 		return ret;
 	}
 
-- 
2.13.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
