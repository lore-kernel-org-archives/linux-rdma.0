From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] librdmacm: Print correct error message from rdma_getaddrinfo
Date: Thu,  9 Nov 2017 10:03:07 +0200
Message-ID: <20171109080307.4825-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A return value of -1 from rdma_getaddrinfo can indicates either
EAI_BADFLAGS returned from getaddrinfo or a generic error returned by
rdma_getaddrinfo itself.

Fix this conflict by printing errno in case it is set, otherwise
gai_strerror.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 librdmacm/examples/cmatose.c      | 6 ++++--
 librdmacm/examples/cmtime.c       | 6 ++++--
 librdmacm/examples/rdma_client.c  | 3 ++-
 librdmacm/examples/rdma_server.c  | 3 ++-
 librdmacm/examples/rdma_xclient.c | 3 ++-
 librdmacm/examples/riostream.c    | 6 ++++--
 librdmacm/examples/rstream.c      | 9 ++++++---
 librdmacm/examples/udaddy.c       | 6 ++++--
 8 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/librdmacm/examples/cmatose.c b/librdmacm/examples/cmatose.c
index b1c9dd13..6f6a99d8 100644
--- a/librdmacm/examples/cmatose.c
+++ b/librdmacm/examples/cmatose.c
@@ -507,7 +507,8 @@ static int run_server(void)
 
 	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &test.rai);
 	if (ret) {
-		printf("cmatose: getrdmaaddr error: %s\n", gai_strerror(ret));
+		printf("cmatose: getrdmaaddr error: %s\n", errno ?
+		       strerror(errno) : gai_strerror(ret));
 		goto out;
 	}
 
@@ -580,7 +581,8 @@ static int run_client(void)
 
 	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &test.rai);
 	if (ret) {
-		printf("cmatose: getaddrinfo error: %s\n", gai_strerror(ret));
+		printf("cmatose: getaddrinfo error: %s\n", errno ?
+		       strerror(errno) : gai_strerror(ret));
 		return ret;
 	}
 
diff --git a/librdmacm/examples/cmtime.c b/librdmacm/examples/cmtime.c
index aa96b901..a7d109dd 100644
--- a/librdmacm/examples/cmtime.c
+++ b/librdmacm/examples/cmtime.c
@@ -462,7 +462,8 @@ static int run_server(void)
 
 	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &rai);
 	if (ret) {
-		printf("getrdmaaddr error: %s\n", gai_strerror(ret));
+		printf("getrdmaaddr error: %s\n", errno ? strerror(errno) :
+						  gai_strerror(ret));
 		goto out;
 	}
 
@@ -491,7 +492,8 @@ static int run_client(void)
 
 	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &rai);
 	if (ret) {
-		printf("getaddrinfo error: %s\n", gai_strerror(ret));
+		printf("getaddrinfo error: %s\n", errno ? strerror(errno) :
+						  gai_strerror(ret));
 		return ret;
 	}
 
diff --git a/librdmacm/examples/rdma_client.c b/librdmacm/examples/rdma_client.c
index c27047c5..de43eb0a 100644
--- a/librdmacm/examples/rdma_client.c
+++ b/librdmacm/examples/rdma_client.c
@@ -56,7 +56,8 @@ static int run(void)
 	hints.ai_port_space = RDMA_PS_TCP;
 	ret = rdma_getaddrinfo(server, port, &hints, &res);
 	if (ret) {
-		printf("rdma_getaddrinfo: %s\n", gai_strerror(ret));
+		printf("rdma_getaddrinfo: %s\n", errno ? strerror(errno) :
+						 gai_strerror(ret));
 		goto out;
 	}
 
diff --git a/librdmacm/examples/rdma_server.c b/librdmacm/examples/rdma_server.c
index bcf649fe..bedd9a73 100644
--- a/librdmacm/examples/rdma_server.c
+++ b/librdmacm/examples/rdma_server.c
@@ -57,7 +57,8 @@ static int run(void)
 	hints.ai_port_space = RDMA_PS_TCP;
 	ret = rdma_getaddrinfo(NULL, port, &hints, &res);
 	if (ret) {
-		printf("rdma_getaddrinfo: %s\n", gai_strerror(ret));
+		printf("rdma_getaddrinfo: %s\n", errno ? strerror(errno) :
+						 gai_strerror(ret));
 		return ret;
 	}
 
diff --git a/librdmacm/examples/rdma_xclient.c b/librdmacm/examples/rdma_xclient.c
index 63dfb6df..687e1deb 100644
--- a/librdmacm/examples/rdma_xclient.c
+++ b/librdmacm/examples/rdma_xclient.c
@@ -82,7 +82,8 @@ static int test(void)
 
 	ret = rdma_getaddrinfo(server, port, &hints, &res);
 	if (ret) {
-		printf("rdma_getaddrinfo: %s\n", gai_strerror(ret));
+		printf("rdma_getaddrinfo: %s\n", errno ? strerror(errno) :
+						 gai_strerror(ret));
 		return ret;
 	}
 
diff --git a/librdmacm/examples/riostream.c b/librdmacm/examples/riostream.c
index bdf4fd34..883f8a82 100644
--- a/librdmacm/examples/riostream.c
+++ b/librdmacm/examples/riostream.c
@@ -363,7 +363,8 @@ static int server_listen(void)
 		ret = getaddrinfo(src_addr, port, &ai_hints, &ai);
 	}
 	if (ret) {
-		printf("getaddrinfo: %s\n", gai_strerror(ret));
+		printf("getaddrinfo: %s\n", errno ? strerror(errno) :
+					    gai_strerror(ret));
 		return ret;
 	}
 
@@ -444,7 +445,8 @@ static int client_connect(void)
 	ret = use_rgai ? rdma_getaddrinfo(dst_addr, port, &rai_hints, &rai) :
 			 getaddrinfo(dst_addr, port, &ai_hints, &ai);
 	if (ret) {
-		printf("getaddrinfo: %s\n", gai_strerror(ret));
+		printf("getaddrinfo: %s\n", errno ? strerror(errno) :
+					    gai_strerror(ret));
 		return ret;
 	}
 
diff --git a/librdmacm/examples/rstream.c b/librdmacm/examples/rstream.c
index 7523269c..11fe6f25 100644
--- a/librdmacm/examples/rstream.c
+++ b/librdmacm/examples/rstream.c
@@ -327,7 +327,8 @@ static int server_listen(void)
 		ret = getaddrinfo(src_addr, port, &ai_hints, &ai);
 	}
 	if (ret) {
-		printf("getaddrinfo: %s\n", gai_strerror(ret));
+		printf("getaddrinfo: %s\n", errno ? strerror(errno) :
+					    gai_strerror(ret));
 		return ret;
 	}
 
@@ -412,7 +413,8 @@ static int client_connect(void)
 			 getaddrinfo(dst_addr, port, &ai_hints, &ai);
 
 	if (ret) {
-		printf("getaddrinfo: %s\n", gai_strerror(ret));
+		printf("getaddrinfo: %s\n", errno ? strerror(errno) :
+					    gai_strerror(ret));
 		return ret;
 	}
 
@@ -425,7 +427,8 @@ static int client_connect(void)
 			ret = getaddrinfo(src_addr, port, &ai_hints, &ai_src);
 		}
 		if (ret) {
-			printf("getaddrinfo src_addr: %s\n", gai_strerror(ret));
+			printf("getaddrinfo src_addr: %s\n", errno ?
+			       strerror(errno) : gai_strerror(ret));
 			return ret;
 		}
 	}
diff --git a/librdmacm/examples/udaddy.c b/librdmacm/examples/udaddy.c
index b1ac90c3..914be0a2 100644
--- a/librdmacm/examples/udaddy.c
+++ b/librdmacm/examples/udaddy.c
@@ -514,7 +514,8 @@ static int run_server(void)
 
 	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &test.rai);
 	if (ret) {
-		printf("udaddy: getrdmaaddr error: %s\n", gai_strerror(ret));
+		printf("udaddy: getrdmaaddr error: %s\n", errno ?
+		       strerror(errno) : gai_strerror(ret));
 		goto out;
 	}
 
@@ -563,7 +564,8 @@ static int run_client(void)
 
 	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &test.rai);
 	if (ret) {
-		printf("udaddy: getaddrinfo error: %s\n", gai_strerror(ret));
+		printf("udaddy: getaddrinfo error: %s\n", errno ?
+		       strerror(errno) : gai_strerror(ret));
 		return ret;
 	}
 
-- 
2.13.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
