From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v2] examples/riostream.c: Add AF_IB support
Date: Tue, 04 Mar 2014 07:08:19 -0500
Message-ID: <5315C233.1080503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow the user to specify GID addresses (AF_IB) into riostream example.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change since v1:
Added brief description

diff --git a/examples/riostream.c b/examples/riostream.c
index a1d3671..4c0d21f 100644
--- a/examples/riostream.c
+++ b/examples/riostream.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2011-2012 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2014 Mellanox Technologies LTD. All rights reserved.
  *
  * This software is available to you under the OpenIB.org BSD license
  * below:
@@ -75,6 +76,7 @@ static struct test_size_param test_size[] = {
 
 static int rs, lrs;
 static int use_async;
+static int use_rgai;
 static int verify;
 static int flags = MSG_DONTWAIT;
 static int poll_timeout = 0;
@@ -92,6 +94,8 @@ static char *src_addr;
 static struct timeval start, end;
 static void *buf;
 static volatile uint8_t *poll_byte;
+static struct rdma_addrinfo rai_hints;
+static struct addrinfo ai_hints;
 
 static void show_perf(void)
 {
@@ -355,18 +359,24 @@ static void set_options(int rs)
 
 static int server_listen(void)
 {
-	struct addrinfo hints, *res;
+	struct rdma_addrinfo *rai = NULL;
+	struct addrinfo *ai;
 	int val, ret;
 
-	memset(&hints, 0, sizeof hints);
-	hints.ai_flags = AI_PASSIVE;
- 	ret = getaddrinfo(src_addr, port, &hints, &res);
+	if (use_rgai) {
+		rai_hints.ai_flags |= RAI_PASSIVE;
+		ret = rdma_getaddrinfo(src_addr, port, &rai_hints, &rai);
+	} else {
+		ai_hints.ai_flags |= AI_PASSIVE;
+		ret = getaddrinfo(src_addr, port, &ai_hints, &ai);
+	}
 	if (ret) {
 		perror("getaddrinfo");
 		return ret;
 	}
 
-	lrs = rsocket(res->ai_family, res->ai_socktype, res->ai_protocol);
+	lrs = rai ? rsocket(rai->ai_family, SOCK_STREAM, 0) :
+		    rsocket(ai->ai_family, SOCK_STREAM, 0);
 	if (lrs < 0) {
 		perror("rsocket");
 		ret = lrs;
@@ -380,7 +390,8 @@ static int server_listen(void)
 		goto close;
 	}
 
-	ret = rbind(lrs, res->ai_addr, res->ai_addrlen);
+	ret = rai ? rbind(lrs, rai->ai_src_addr, rai->ai_src_len) :
+		    rbind(lrs, ai->ai_addr, ai->ai_addrlen);
 	if (ret) {
 		perror("rbind");
 		goto close;
@@ -394,7 +405,10 @@ close:
 	if (ret)
 		rclose(lrs);
 free:
-	freeaddrinfo(res);
+	if (rai)
+		rdma_freeaddrinfo(rai);
+	else
+		freeaddrinfo(ai);
 	return ret;
 }
 
@@ -429,18 +443,21 @@ static int server_connect(void)
 
 static int client_connect(void)
 {
-	struct addrinfo *res;
+	struct rdma_addrinfo *rai = NULL;
+	struct addrinfo *ai;
 	struct pollfd fds;
 	int ret, err;
 	socklen_t len;
 
- 	ret = getaddrinfo(dst_addr, port, NULL, &res);
+	ret = use_rgai ? rdma_getaddrinfo(dst_addr, port, &rai_hints, &rai) :
+			 getaddrinfo(dst_addr, port, &ai_hints, &ai);
 	if (ret) {
 		perror("getaddrinfo");
 		return ret;
 	}
 
-	rs = rsocket(res->ai_family, res->ai_socktype, res->ai_protocol);
+	rs = rai ? rsocket(rai->ai_family, SOCK_STREAM, 0) :
+		   rsocket(ai->ai_family, SOCK_STREAM, 0);
 	if (rs < 0) {
 		perror("rsocket");
 		ret = rs;
@@ -450,7 +467,8 @@ static int client_connect(void)
 	set_options(rs);
 	/* TODO: bind client to src_addr */
 
-	ret = rconnect(rs, res->ai_addr, res->ai_addrlen);
+	ret = rai ? rconnect(rs, rai->ai_dst_addr, rai->ai_dst_len) :
+		    rconnect(rs, ai->ai_addr, ai->ai_addrlen);
 	if (ret && (errno != EINPROGRESS)) {
 		perror("rconnect");
 		goto close;
@@ -478,7 +496,10 @@ close:
 	if (ret)
 		rclose(rs);
 free:
-	freeaddrinfo(res);
+	if (rai)
+		rdma_freeaddrinfo(rai);
+	else
+		freeaddrinfo(ai);
 	return ret;
 }
 
@@ -579,7 +600,9 @@ int main(int argc, char **argv)
 {
 	int op, ret;
 
-	while ((op = getopt(argc, argv, "s:b:B:I:C:S:p:T:")) != -1) {
+	ai_hints.ai_socktype = SOCK_STREAM;
+	rai_hints.ai_port_space = RDMA_PS_TCP;
+	while ((op = getopt(argc, argv, "s:b:f:B:I:C:S:p:T:")) != -1) {
 		switch (op) {
 		case 's':
 			dst_addr = optarg;
@@ -587,6 +610,17 @@ int main(int argc, char **argv)
 		case 'b':
 			src_addr = optarg;
 			break;
+		case 'f':
+			if (!strncasecmp("ip", optarg, 2)) {
+				ai_hints.ai_flags = AI_NUMERICHOST;
+			} else if (!strncasecmp("gid", optarg, 3)) {
+				rai_hints.ai_flags = RAI_NUMERICHOST | RAI_FAMILY;
+				rai_hints.ai_family = AF_IB;
+				use_rgai = 1;
+			} else {
+				fprintf(stderr, "Warning: unknown address format\n");
+			}
+			break;
 		case 'B':
 			buffer_size = atoi(optarg);
 			break;
@@ -617,6 +651,8 @@ int main(int argc, char **argv)
 			printf("usage: %s\n", argv[0]);
 			printf("\t[-s server_address]\n");
 			printf("\t[-b bind_address]\n");
+			printf("\t[-f address_format]\n");
+			printf("\t    name, ip, ipv6, or gid\n");
 			printf("\t[-B buffer_size]\n");
 			printf("\t[-I iterations]\n");
 			printf("\t[-C transfer_count]\n");
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
