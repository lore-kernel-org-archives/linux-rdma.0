From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH librdmacm] examples: Use gai_strerror rather than perror for
 [rdma_]getaddrinfo failures
Date: Wed, 30 Sep 2015 09:02:04 -0400
Message-ID: <560BDD4C.8070600@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


[rdma_]getaddrinfo error codes are decoded by gai_strerror (and not
set in errno) so replace perror calls following these failed calls. 

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/examples/cmatose.c b/examples/cmatose.c
index ab3e746..d7bd92d 100644
--- a/examples/cmatose.c
+++ b/examples/cmatose.c
@@ -509,7 +509,7 @@ static int run_server(void)
 
 	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &test.rai);
 	if (ret) {
-		perror("cmatose: getrdmaaddr error");
+		printf("cmatose: getrdmaaddr error: %s\n", gai_strerror(ret));
 		goto out;
 	}
 
@@ -582,7 +582,7 @@ static int run_client(void)
 
 	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &test.rai);
 	if (ret) {
-		perror("cmatose: getaddrinfo error");
+		printf("cmatose: getaddrinfo error: %s\n", gai_strerror(ret));
 		return ret;
 	}
 
diff --git a/examples/cmtime.c b/examples/cmtime.c
index ebc660b..e45980b 100644
--- a/examples/cmtime.c
+++ b/examples/cmtime.c
@@ -479,7 +479,7 @@ static int run_server(void)
 
 	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &rai);
 	if (ret) {
-		perror("getrdmaaddr error");
+		printf("getrdmaaddr error: %s\n", gai_strerror(ret));
 		goto out;
 	}
 
@@ -508,7 +508,7 @@ static int run_client(void)
 
 	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &rai);
 	if (ret) {
-		perror("getaddrinfo error");
+		printf("getaddrinfo error: %s\n", gai_strerror(ret));
 		return ret;
 	}
 
diff --git a/examples/mckey.c b/examples/mckey.c
index a6b5c4d..2032aa9 100644
--- a/examples/mckey.c
+++ b/examples/mckey.c
@@ -452,7 +452,7 @@ static int get_addr(char *dst, struct sockaddr *addr)
 
 	ret = getaddrinfo(dst, NULL, NULL, &res);
 	if (ret) {
-		printf("getaddrinfo failed - invalid hostname or IP address\n");
+		printf("getaddrinfo failed (%s) - invalid hostname or IP address\n", gai_strerror(ret));
 		return ret;
 	}
 
diff --git a/examples/rcopy.c b/examples/rcopy.c
index 152acef..085b017 100644
--- a/examples/rcopy.c
+++ b/examples/rcopy.c
@@ -186,7 +186,7 @@ static int server_listen(void)
 	hints.ai_flags = RAI_PASSIVE;
  	ret = getaddrinfo(NULL, port, &hints, &res);
 	if (ret) {
-		perror("getaddrinfo failed\n");
+		printf("getaddrinfo failed: %s\n", gai_strerror(ret));
 		return ret;
 	}
 
@@ -396,7 +396,7 @@ static int client_connect(void)
 
  	ret = getaddrinfo(dst_addr, port, NULL, &res);
 	if (ret) {
-		perror("getaddrinfo failed\n");
+		printf("getaddrinfo failed: %s\n", gai_strerror(ret));
 		return ret;
 	}
 
diff --git a/examples/rdma_client.c b/examples/rdma_client.c
index f676b70..d7f65f5 100644
--- a/examples/rdma_client.c
+++ b/examples/rdma_client.c
@@ -30,6 +30,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <netdb.h>
 #include <errno.h>
 #include <getopt.h>
 #include <rdma/rdma_cma.h>
@@ -55,7 +56,7 @@ static int run(void)
 	hints.ai_port_space = RDMA_PS_TCP;
 	ret = rdma_getaddrinfo(server, port, &hints, &res);
 	if (ret) {
-		perror("rdma_getaddrinfo");
+		printf("rdma_getaddrinfo: %s\n", gai_strerror(ret));
 		goto out;
 	}
 
diff --git a/examples/rdma_server.c b/examples/rdma_server.c
index 129cf42..d98d11a 100644
--- a/examples/rdma_server.c
+++ b/examples/rdma_server.c
@@ -57,7 +57,7 @@ static int run(void)
 	hints.ai_port_space = RDMA_PS_TCP;
 	ret = rdma_getaddrinfo(NULL, port, &hints, &res);
 	if (ret) {
-		perror("rdma_getaddrinfo");
+		printf("rdma_getaddrinfo: %s\n", gai_strerror(ret));
 		return ret;
 	}
 
diff --git a/examples/rdma_xclient.c b/examples/rdma_xclient.c
index 6510408..8dba266 100644
--- a/examples/rdma_xclient.c
+++ b/examples/rdma_xclient.c
@@ -30,6 +30,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <netdb.h>
 #include <errno.h>
 #include <getopt.h>
 #include <ctype.h>
@@ -80,7 +81,7 @@ static int test(void)
 
 	ret = rdma_getaddrinfo(server, port, &hints, &res);
 	if (ret) {
-		perror("rdma_getaddrinfo");
+		printf("rdma_getaddrinfo: %s\n", gai_strerror(ret));
 		return ret;
 	}
 
diff --git a/examples/rdma_xserver.c b/examples/rdma_xserver.c
index d30c88e..69f170b 100644
--- a/examples/rdma_xserver.c
+++ b/examples/rdma_xserver.c
@@ -78,7 +78,7 @@ static int test(void)
 
 	ret = rdma_getaddrinfo(NULL, port, &hints, &res);
 	if (ret) {
-		perror("rdma_getaddrinfo");
+		printf("rdma_getaddrinfo: %s\n", gai_strerror(ret));
 		return ret;
 	}
 
diff --git a/examples/riostream.c b/examples/riostream.c
index c12dd0d..82dcd59 100644
--- a/examples/riostream.c
+++ b/examples/riostream.c
@@ -363,7 +363,7 @@ static int server_listen(void)
 		ret = getaddrinfo(src_addr, port, &ai_hints, &ai);
 	}
 	if (ret) {
-		perror("getaddrinfo");
+		printf("getaddrinfo: %s\n", gai_strerror(ret));
 		return ret;
 	}
 
@@ -444,7 +444,7 @@ static int client_connect(void)
 	ret = use_rgai ? rdma_getaddrinfo(dst_addr, port, &rai_hints, &rai) :
 			 getaddrinfo(dst_addr, port, &ai_hints, &ai);
 	if (ret) {
-		perror("getaddrinfo");
+		printf("getaddrinfo: %s\n", gai_strerror(ret));
 		return ret;
 	}
 
diff --git a/examples/rping.c b/examples/rping.c
index 9486314..a5aa8c5 100644
--- a/examples/rping.c
+++ b/examples/rping.c
@@ -1122,7 +1122,7 @@ static int get_addr(char *dst, struct sockaddr *addr)
 
 	ret = getaddrinfo(dst, NULL, NULL, &res);
 	if (ret) {
-		printf("getaddrinfo failed - invalid hostname or IP address\n");
+		printf("getaddrinfo failed (%s) - invalid hostname or IP address\n", gai_strerror(ret));
 		return ret;
 	}
 
diff --git a/examples/rstream.c b/examples/rstream.c
index d93e9aa..c88b5b7 100644
--- a/examples/rstream.c
+++ b/examples/rstream.c
@@ -327,7 +327,7 @@ static int server_listen(void)
 		ret = getaddrinfo(src_addr, port, &ai_hints, &ai);
 	}
 	if (ret) {
-		perror("getaddrinfo");
+		printf("getaddrinfo: %s\n", gai_strerror(ret));
 		return ret;
 	}
 
@@ -412,7 +412,7 @@ static int client_connect(void)
 			 getaddrinfo(dst_addr, port, &ai_hints, &ai);
 
 	if (ret) {
-		perror("getaddrinfo");
+		printf("getaddrinfo: %s\n", gai_strerror(ret));
 		return ret;
 	}
 
@@ -425,7 +425,7 @@ static int client_connect(void)
 			ret = getaddrinfo(src_addr, port, &ai_hints, &ai_src);
 		}
 		if (ret) {
-			perror("getaddrinfo src_addr");
+			printf("getaddrinfo src_addr: %s\n", gai_strerror(ret));
 			return ret;
 		}
 	}
diff --git a/examples/udaddy.c b/examples/udaddy.c
index 6e68944..5e89ca1 100644
--- a/examples/udaddy.c
+++ b/examples/udaddy.c
@@ -516,7 +516,7 @@ static int run_server(void)
 
 	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &test.rai);
 	if (ret) {
-		perror("cmatose: getrdmaaddr error");
+		printf("udaddy: getrdmaaddr error: %s\n", gai_strerror(ret));
 		goto out;
 	}
 
@@ -565,7 +565,7 @@ static int run_client(void)
 
 	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &test.rai);
 	if (ret) {
-		perror("udaddy: getaddrinfo error");
+		printf("udaddy: getaddrinfo error: %s\n", gai_strerror(ret));
 		return ret;
 	}
 
diff --git a/examples/udpong.c b/examples/udpong.c
index 7ec11e8..97713a2 100644
--- a/examples/udpong.c
+++ b/examples/udpong.c
@@ -266,7 +266,7 @@ static int svr_bind(void)
 	hints.ai_socktype = SOCK_DGRAM;
  	ret = getaddrinfo(src_addr, port, &hints, &res);
 	if (ret) {
-		perror("getaddrinfo");
+		printf("getaddrinfo: %s\n", gai_strerror(ret));
 		return ret;
 	}
 
@@ -411,7 +411,7 @@ static int client_connect(void)
 	hints.ai_socktype = SOCK_DGRAM;
  	ret = getaddrinfo(dst_addr, port, &hints, &res);
 	if (ret) {
-		perror("getaddrinfo");
+		printf("getaddrinfo: %s\n", gai_strerror(ret));
 		return ret;
 	}
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
