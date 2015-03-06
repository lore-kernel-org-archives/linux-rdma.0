From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH librdmacm] rstream.c: Add missing binding to source address
 in client_connect
Date: Fri, 06 Mar 2015 09:58:45 -0500
Message-ID: <54F9C0A5.5010909@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This is needed for IPv6 connections.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/examples/rstream.c b/examples/rstream.c
index 05598a8..d93e9aa 100644
--- a/examples/rstream.c
+++ b/examples/rstream.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2011-2012 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2014-2015 Mellanox Technologies LTD. All rights reserved.
  *
  * This software is available to you under the OpenIB.org BSD license
  * below:
@@ -401,8 +402,8 @@ static int server_connect(void)
 
 static int client_connect(void)
 {
-	struct rdma_addrinfo *rai = NULL;
-	struct addrinfo *ai;
+	struct rdma_addrinfo *rai = NULL, *rai_src = NULL;
+	struct addrinfo *ai, *ai_src;
 	struct pollfd fds;
 	int ret, err;
 	socklen_t len;
@@ -415,6 +416,20 @@ static int client_connect(void)
 		return ret;
 	}
 
+	if (src_addr) {
+		if (use_rgai) {
+			rai_hints.ai_flags |= RAI_PASSIVE;
+			ret = rdma_getaddrinfo(src_addr, port, &rai_hints, &rai_src);
+		} else {
+			ai_hints.ai_flags |= RAI_PASSIVE;
+			ret = getaddrinfo(src_addr, port, &ai_hints, &ai_src);
+		}
+		if (ret) {
+			perror("getaddrinfo src_addr");
+			return ret;
+		}
+	}
+
 	rs = rai ? rs_socket(rai->ai_family, SOCK_STREAM, 0) :
 		   rs_socket(ai->ai_family, SOCK_STREAM, 0);
 	if (rs < 0) {
@@ -424,7 +439,15 @@ static int client_connect(void)
 	}
 
 	set_options(rs);
-	/* TODO: bind client to src_addr */
+
+	if (src_addr) {
+		ret = rai ? rs_bind(rs, rai_src->ai_src_addr, rai_src->ai_src_len) :
+			    rs_bind(rs, ai_src->ai_addr, ai_src->ai_addrlen);
+		if (ret) {
+			perror("rbind");
+			goto close;
+		}
+	}
 
 	if (rai && rai->ai_route) {
 		ret = rs_setsockopt(rs, SOL_RDMA, RDMA_ROUTE, rai->ai_route,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
