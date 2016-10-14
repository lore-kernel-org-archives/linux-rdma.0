From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 8/8] Enable -Wshadow
Date: Fri, 14 Oct 2016 16:14:17 -0600
Message-ID: <1476483257-16308-9-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1476483257-16308-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476483257-16308-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Having multiple objects with the same name in the same scope is
almost always confusing. Make some trivial changes to avoid those
few cases.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                      | 17 +++++++++++
 ibacm/prov/acmp/src/acmp.c          | 10 +++----
 libibverbs/examples/srq_pingpong.c  |  1 -
 libibverbs/examples/xsrq_pingpong.c |  6 ++--
 libibverbs/verbs.h                  |  6 ++--
 librdmacm/examples/riostream.c      | 34 ++++++++++-----------
 librdmacm/examples/rstream.c        | 50 +++++++++++++++----------------
 librdmacm/examples/udpong.c         | 60 ++++++++++++++++++-------------------
 providers/mthca/cq.c                |  2 +-
 9 files changed, 101 insertions(+), 85 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 8f21ba384c12..375859d04914 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -115,6 +115,20 @@ RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WMISSING_DECLARATIONS "-Wmissing-declarati
 RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WWRITE_STRINGS "-Wwrite-strings")
 RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WFORMAT_2 "-Wformat=2")
 
+# At some point after 4.4 gcc fixed shadow to ignore function vs variable
+# conflicts
+set(SAFE_CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS}")
+  set(CMAKE_REQUIRED_FLAGS "-Wshadow")
+CHECK_C_SOURCE_COMPILES("
+ #include <unistd.h>
+ int main(int argc,const char *argv[]) { int access = 1; return access; }"
+  HAVE_C_WORKING_SHADOW
+  FAIL_REGEX "warning")
+if (HAVE_C_WORKING_SHADOW)
+  RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WORKING_SHADOW "-Wshadow")
+endif()
+set(CMAKE_REQUIRED_FLAGS "${SAFE_CMAKE_REQUIRED_FLAGS}")
+
 # At some point around 5.4 gcc fixed missing-field-initializers to ignore this
 # common idiom we use extensively. Since this is a useful warning for
 # developers try and leave it on if the compiler supports it.
@@ -372,6 +386,9 @@ endif()
 if (NOT HAVE_C_WORKING_MISSING_FIELD_INITIALIZERS)
   message(STATUS " -Wmissing-field-initializers does NOT work")
 endif()
+if (NOT HAVE_C_WORKING_SHADOW)
+  message(STATUS " -Wshadow does NOT work")
+endif()
 if (NOT HAVE_C_WREDUNDANT_DECLS)
   message(STATUS " -Wredundant-decls does NOT work")
 endif()
diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index fd579dff9d4e..806320ffffd5 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -252,7 +252,7 @@ static struct acm_provider def_prov = {
 static DLIST_ENTRY acmp_dev_list;
 static lock_t acmp_dev_lock;
 
-static atomic_t tid;
+static atomic_t g_tid;
 static DLIST_ENTRY timeout_list;
 static event_t timeout_event;
 static atomic_t wait_cnt;
@@ -787,7 +787,7 @@ static void acmp_init_path_query(struct ib_sa_mad *mad)
 	mad->mgmt_class = IB_MGMT_CLASS_SA;
 	mad->class_version = 2;
 	mad->method = IB_METHOD_GET;
-	mad->tid = htonll((uint64_t) atomic_inc(&tid));
+	mad->tid = htonll((uint64_t) atomic_inc(&g_tid));
 	mad->attr_id = IB_SA_ATTR_PATH_REC;
 }
 
@@ -1378,7 +1378,7 @@ static void acmp_init_join(struct ib_sa_mad *mad, union ibv_gid *port_gid,
 	mad->mgmt_class = IB_MGMT_CLASS_SA;
 	mad->class_version = 2;
 	mad->method = IB_METHOD_SET;
-	mad->tid = htonll((uint64_t) atomic_inc(&tid));
+	mad->tid = htonll((uint64_t) atomic_inc(&g_tid));
 	mad->attr_id = IB_SA_ATTR_MC_MEMBER_REC;
 	mad->comp_mask =
 		IB_COMP_MASK_MC_MGID | IB_COMP_MASK_MC_PORT_GID |
@@ -1703,7 +1703,7 @@ acmp_send_resolve(struct acmp_ep *ep, struct acmp_dest *dest,
 	mad->class_version = 1;
 	mad->method = IB_METHOD_GET;
 	mad->control = ACM_CTRL_RESOLVE;
-	mad->tid = htonll((uint64_t) atomic_inc(&tid));
+	mad->tid = htonll((uint64_t) atomic_inc(&g_tid));
 
 	rec = (struct acm_resolve_rec *) mad->data;
 	rec->src_type = (uint8_t) saddr->type;
@@ -2948,7 +2948,7 @@ static void __attribute__((constructor)) acmp_init(void)
 
 	acmp_log_options();
 
-	atomic_init(&tid);
+	atomic_init(&g_tid);
 	atomic_init(&wait_cnt);
 	DListInit(&acmp_dev_list);
 	lock_init(&acmp_dev_lock);
diff --git a/libibverbs/examples/srq_pingpong.c b/libibverbs/examples/srq_pingpong.c
index e2993bfdacbf..30d81f0e4f31 100644
--- a/libibverbs/examples/srq_pingpong.c
+++ b/libibverbs/examples/srq_pingpong.c
@@ -770,7 +770,6 @@ int main(int argc, char *argv[])
 			return 1;
 		}
 	} else {
-		int i;
 		for (i = 0; dev_list[i]; ++i)
 			if (!strcmp(ibv_get_device_name(dev_list[i]), ib_devname))
 				break;
diff --git a/libibverbs/examples/xsrq_pingpong.c b/libibverbs/examples/xsrq_pingpong.c
index b90f0eb7e27f..5fb8827579dd 100644
--- a/libibverbs/examples/xsrq_pingpong.c
+++ b/libibverbs/examples/xsrq_pingpong.c
@@ -456,13 +456,13 @@ static int recv_remote_dest(int sockfd, int index)
 	return 0;
 }
 
-static void set_ah_attr(struct ibv_ah_attr *attr, struct pingpong_context *ctx,
+static void set_ah_attr(struct ibv_ah_attr *attr, struct pingpong_context *myctx,
 			int index)
 {
 	attr->is_global = 1;
 	attr->grh.hop_limit = 5;
-	attr->grh.dgid = ctx->rem_dest[index].gid;
-	attr->grh.sgid_index = ctx->gidx;
+	attr->grh.dgid = myctx->rem_dest[index].gid;
+	attr->grh.sgid_index = myctx->gidx;
 }
 
 static int connect_qps(int index)
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index e994c21c267f..a2ccaaf141ab 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1459,9 +1459,9 @@ static inline struct verbs_context *verbs_get_ctx(struct ibv_context *ctx)
 }
 
 #define verbs_get_ctx_op(ctx, op) ({ \
-	struct verbs_context *vctx = verbs_get_ctx(ctx); \
-	(!vctx || (vctx->sz < sizeof(*vctx) - offsetof(struct verbs_context, op)) || \
-	 !vctx->op) ? NULL : vctx; })
+	struct verbs_context *__vctx = verbs_get_ctx(ctx); \
+	(!__vctx || (__vctx->sz < sizeof(*__vctx) - offsetof(struct verbs_context, op)) || \
+	 !__vctx->op) ? NULL : __vctx; })
 
 #define verbs_set_ctx_op(_vctx, op, ptr) ({ \
 	struct verbs_context *vctx = _vctx; \
diff --git a/librdmacm/examples/riostream.c b/librdmacm/examples/riostream.c
index bd8c60cdcb1d..d9e5fd6eb0a6 100644
--- a/librdmacm/examples/riostream.c
+++ b/librdmacm/examples/riostream.c
@@ -317,35 +317,35 @@ out:
 	return ret;
 }
 
-static void set_options(int rs)
+static void set_options(int fd)
 {
 	int val;
 
 	if (buffer_size) {
-		rsetsockopt(rs, SOL_SOCKET, SO_SNDBUF, (void *) &buffer_size,
+		rsetsockopt(fd, SOL_SOCKET, SO_SNDBUF, (void *) &buffer_size,
 			    sizeof buffer_size);
-		rsetsockopt(rs, SOL_SOCKET, SO_RCVBUF, (void *) &buffer_size,
+		rsetsockopt(fd, SOL_SOCKET, SO_RCVBUF, (void *) &buffer_size,
 			    sizeof buffer_size);
 	} else {
 		val = 1 << 19;
-		rsetsockopt(rs, SOL_SOCKET, SO_SNDBUF, (void *) &val, sizeof val);
-		rsetsockopt(rs, SOL_SOCKET, SO_RCVBUF, (void *) &val, sizeof val);
+		rsetsockopt(fd, SOL_SOCKET, SO_SNDBUF, (void *) &val, sizeof val);
+		rsetsockopt(fd, SOL_SOCKET, SO_RCVBUF, (void *) &val, sizeof val);
 	}
 
 	val = 1;
-	rsetsockopt(rs, IPPROTO_TCP, TCP_NODELAY, (void *) &val, sizeof(val));
-	rsetsockopt(rs, SOL_RDMA, RDMA_IOMAPSIZE, (void *) &val, sizeof val);
+	rsetsockopt(fd, IPPROTO_TCP, TCP_NODELAY, (void *) &val, sizeof(val));
+	rsetsockopt(fd, SOL_RDMA, RDMA_IOMAPSIZE, (void *) &val, sizeof val);
 
 	if (flags & MSG_DONTWAIT)
-		rfcntl(rs, F_SETFL, O_NONBLOCK);
+		rfcntl(fd, F_SETFL, O_NONBLOCK);
 
 	/* Inline size based on experimental data */
 	if (optimization == opt_latency) {
-		rsetsockopt(rs, SOL_RDMA, RDMA_INLINE, &inline_size,
+		rsetsockopt(fd, SOL_RDMA, RDMA_INLINE, &inline_size,
 			    sizeof inline_size);
 	} else if (optimization == opt_bandwidth) {
 		val = 0;
-		rsetsockopt(rs, SOL_RDMA, RDMA_INLINE, &val, sizeof val);
+		rsetsockopt(fd, SOL_RDMA, RDMA_INLINE, &val, sizeof val);
 	}
 }
 
@@ -555,10 +555,10 @@ free:
 	return ret;
 }
 
-static int set_test_opt(char *optarg)
+static int set_test_opt(const char *arg)
 {
-	if (strlen(optarg) == 1) {
-		switch (optarg[0]) {
+	if (strlen(arg) == 1) {
+		switch (arg[0]) {
 		case 'a':
 			use_async = 1;
 			break;
@@ -575,13 +575,13 @@ static int set_test_opt(char *optarg)
 			return -1;
 		}
 	} else {
-		if (!strncasecmp("async", optarg, 5)) {
+		if (!strncasecmp("async", arg, 5)) {
 			use_async = 1;
-		} else if (!strncasecmp("block", optarg, 5)) {
+		} else if (!strncasecmp("block", arg, 5)) {
 			flags = (flags & ~MSG_DONTWAIT) | MSG_WAITALL;
-		} else if (!strncasecmp("nonblock", optarg, 8)) {
+		} else if (!strncasecmp("nonblock", arg, 8)) {
 			flags |= MSG_DONTWAIT;
-		} else if (!strncasecmp("verify", optarg, 6)) {
+		} else if (!strncasecmp("verify", arg, 6)) {
 			verify = 1;
 		} else {
 			return -1;
diff --git a/librdmacm/examples/rstream.c b/librdmacm/examples/rstream.c
index 59a0d4351ef5..14799c997128 100644
--- a/librdmacm/examples/rstream.c
+++ b/librdmacm/examples/rstream.c
@@ -255,62 +255,62 @@ out:
 	return ret;
 }
 
-static void set_keepalive(int rs)
+static void set_keepalive(int fd)
 {
 	int optval;
 	socklen_t optlen = sizeof(optlen);
 
 	optval = 1;
-	if (rs_setsockopt(rs, SOL_SOCKET, SO_KEEPALIVE, &optval, optlen)) {
+	if (rs_setsockopt(fd, SOL_SOCKET, SO_KEEPALIVE, &optval, optlen)) {
 		perror("rsetsockopt SO_KEEPALIVE");
 		return;
 	}
 
 	optval = keepalive;
-	if (rs_setsockopt(rs, IPPROTO_TCP, TCP_KEEPIDLE, &optval, optlen))
+	if (rs_setsockopt(fd, IPPROTO_TCP, TCP_KEEPIDLE, &optval, optlen))
 		perror("rsetsockopt TCP_KEEPIDLE");
 
-	if (!(rs_getsockopt(rs, SOL_SOCKET, SO_KEEPALIVE, &optval, &optlen)))
+	if (!(rs_getsockopt(fd, SOL_SOCKET, SO_KEEPALIVE, &optval, &optlen)))
 		printf("Keepalive: %s\n", (optval ? "ON" : "OFF"));
 
-	if (!(rs_getsockopt(rs, IPPROTO_TCP, TCP_KEEPIDLE, &optval, &optlen)))
+	if (!(rs_getsockopt(fd, IPPROTO_TCP, TCP_KEEPIDLE, &optval, &optlen)))
 		printf("  time: %i\n", optval);
 }
 
-static void set_options(int rs)
+static void set_options(int fd)
 {
 	int val;
 
 	if (buffer_size) {
-		rs_setsockopt(rs, SOL_SOCKET, SO_SNDBUF, (void *) &buffer_size,
+		rs_setsockopt(fd, SOL_SOCKET, SO_SNDBUF, (void *) &buffer_size,
 			      sizeof buffer_size);
-		rs_setsockopt(rs, SOL_SOCKET, SO_RCVBUF, (void *) &buffer_size,
+		rs_setsockopt(fd, SOL_SOCKET, SO_RCVBUF, (void *) &buffer_size,
 			      sizeof buffer_size);
 	} else {
 		val = 1 << 19;
-		rs_setsockopt(rs, SOL_SOCKET, SO_SNDBUF, (void *) &val, sizeof val);
-		rs_setsockopt(rs, SOL_SOCKET, SO_RCVBUF, (void *) &val, sizeof val);
+		rs_setsockopt(fd, SOL_SOCKET, SO_SNDBUF, (void *) &val, sizeof val);
+		rs_setsockopt(fd, SOL_SOCKET, SO_RCVBUF, (void *) &val, sizeof val);
 	}
 
 	val = 1;
-	rs_setsockopt(rs, IPPROTO_TCP, TCP_NODELAY, (void *) &val, sizeof(val));
+	rs_setsockopt(fd, IPPROTO_TCP, TCP_NODELAY, (void *) &val, sizeof(val));
 
 	if (flags & MSG_DONTWAIT)
-		rs_fcntl(rs, F_SETFL, O_NONBLOCK);
+		rs_fcntl(fd, F_SETFL, O_NONBLOCK);
 
 	if (use_rs) {
 		/* Inline size based on experimental data */
 		if (optimization == opt_latency) {
-			rs_setsockopt(rs, SOL_RDMA, RDMA_INLINE, &inline_size,
+			rs_setsockopt(fd, SOL_RDMA, RDMA_INLINE, &inline_size,
 				      sizeof inline_size);
 		} else if (optimization == opt_bandwidth) {
 			val = 0;
-			rs_setsockopt(rs, SOL_RDMA, RDMA_INLINE, &val, sizeof val);
+			rs_setsockopt(fd, SOL_RDMA, RDMA_INLINE, &val, sizeof val);
 		}
 	}
 
 	if (keepalive)
-		set_keepalive(rs);
+		set_keepalive(fd);
 }
 
 static int server_listen(void)
@@ -564,10 +564,10 @@ free:
 	return ret;
 }
 
-static int set_test_opt(char *optarg)
+static int set_test_opt(const char *arg)
 {
-	if (strlen(optarg) == 1) {
-		switch (optarg[0]) {
+	if (strlen(arg) == 1) {
+		switch (arg[0]) {
 		case 's':
 			use_rs = 0;
 			break;
@@ -594,19 +594,19 @@ static int set_test_opt(char *optarg)
 			return -1;
 		}
 	} else {
-		if (!strncasecmp("socket", optarg, 6)) {
+		if (!strncasecmp("socket", arg, 6)) {
 			use_rs = 0;
-		} else if (!strncasecmp("async", optarg, 5)) {
+		} else if (!strncasecmp("async", arg, 5)) {
 			use_async = 1;
-		} else if (!strncasecmp("block", optarg, 5)) {
+		} else if (!strncasecmp("block", arg, 5)) {
 			flags = (flags & ~MSG_DONTWAIT) | MSG_WAITALL;
-		} else if (!strncasecmp("nonblock", optarg, 8)) {
+		} else if (!strncasecmp("nonblock", arg, 8)) {
 			flags |= MSG_DONTWAIT;
-		} else if (!strncasecmp("resolve", optarg, 7)) {
+		} else if (!strncasecmp("resolve", arg, 7)) {
 			use_rgai = 1;
-		} else if (!strncasecmp("verify", optarg, 6)) {
+		} else if (!strncasecmp("verify", arg, 6)) {
 			verify = 1;
-		} else if (!strncasecmp("fork", optarg, 4)) {
+		} else if (!strncasecmp("fork", arg, 4)) {
 			use_fork = 1;
 			use_rs = 0;
 		} else {
diff --git a/librdmacm/examples/udpong.c b/librdmacm/examples/udpong.c
index f8d56073012a..71528f226769 100644
--- a/librdmacm/examples/udpong.c
+++ b/librdmacm/examples/udpong.c
@@ -96,10 +96,10 @@ static char test_name[10] = "custom";
 static const char *port = "7174";
 static char *dst_addr;
 static char *src_addr;
-static union socket_addr addr;
-static socklen_t addrlen;
+static union socket_addr g_addr;
+static socklen_t g_addrlen;
 static struct timeval start, end;
-static struct message msg;
+static struct message g_msg;
 
 static void show_perf(void)
 {
@@ -109,7 +109,7 @@ static void show_perf(void)
 	int transfers;
 
 	usec = (end.tv_sec - start.tv_sec) * 1000000 + (end.tv_usec - start.tv_usec);
-	transfers = echo ? transfer_count * 2 : ntohl(msg.data);
+	transfers = echo ? transfer_count * 2 : ntohl(g_msg.data);
 	bytes = (long long) transfers * transfer_size;
 
 	/* name size transfers bytes seconds Gb/sec usec/xfer */
@@ -147,23 +147,23 @@ static void init_bandwidth_test(int size)
 	echo = 0;
 }
 
-static void set_options(int rs)
+static void set_options(int fd)
 {
 	int val;
 
 	if (buffer_size) {
-		rs_setsockopt(rs, SOL_SOCKET, SO_SNDBUF, (void *) &buffer_size,
+		rs_setsockopt(fd, SOL_SOCKET, SO_SNDBUF, (void *) &buffer_size,
 			      sizeof buffer_size);
-		rs_setsockopt(rs, SOL_SOCKET, SO_RCVBUF, (void *) &buffer_size,
+		rs_setsockopt(fd, SOL_SOCKET, SO_RCVBUF, (void *) &buffer_size,
 			      sizeof buffer_size);
 	} else {
 		val = 1 << 19;
-		rs_setsockopt(rs, SOL_SOCKET, SO_SNDBUF, (void *) &val, sizeof val);
-		rs_setsockopt(rs, SOL_SOCKET, SO_RCVBUF, (void *) &val, sizeof val);
+		rs_setsockopt(fd, SOL_SOCKET, SO_SNDBUF, (void *) &val, sizeof val);
+		rs_setsockopt(fd, SOL_SOCKET, SO_RCVBUF, (void *) &val, sizeof val);
 	}
 
 	if (flags & MSG_DONTWAIT)
-		rs_fcntl(rs, F_SETFL, O_NONBLOCK);
+		rs_fcntl(fd, F_SETFL, O_NONBLOCK);
 }
 
 static ssize_t svr_send(struct message *msg, size_t size,
@@ -296,12 +296,12 @@ static int svr_run(void)
 
 	ret = svr_bind();
 	while (!ret) {
-		addrlen = sizeof addr;
-		len = svr_recv(&msg, sizeof msg, &addr, &addrlen);
+		g_addrlen = sizeof g_addr;
+		len = svr_recv(&g_msg, sizeof g_msg, &g_addr, &g_addrlen);
 		if (len < 0)
 			return len;
 
-		ret = svr_process(&msg, len, &addr, addrlen);
+		ret = svr_process(&g_msg, len, &g_addr, g_addrlen);
 	}
 	return ret;
 }
@@ -375,22 +375,22 @@ static int run_test(void)
 {
 	int ret, i;
 
-	msg.op = msg_op_start;
-	ret = client_send_recv(&msg, CTRL_MSG_SIZE, 1000);
+	g_msg.op = msg_op_start;
+	ret = client_send_recv(&g_msg, CTRL_MSG_SIZE, 1000);
 	if (ret != CTRL_MSG_SIZE)
 		goto out;
 
-	msg.op = echo ? msg_op_echo : msg_op_data;
+	g_msg.op = echo ? msg_op_echo : msg_op_data;
 	gettimeofday(&start, NULL);
 	for (i = 0; i < transfer_count; i++) {
-		ret = echo ? client_send_recv(&msg, transfer_size, 1) :
-			     client_send(&msg, transfer_size);
+		ret = echo ? client_send_recv(&g_msg, transfer_size, 1) :
+			     client_send(&g_msg, transfer_size);
 		if (ret != transfer_size)
 			goto out;
 	}
 
-	msg.op = msg_op_end;
-	ret = client_send_recv(&msg, CTRL_MSG_SIZE, 1);
+	g_msg.op = msg_op_end;
+	ret = client_send_recv(&g_msg, CTRL_MSG_SIZE, 1);
 	if (ret != CTRL_MSG_SIZE)
 		goto out;
 
@@ -430,8 +430,8 @@ static int client_connect(void)
 		goto out;
 	}
 
-	msg.op = msg_op_login;
-	ret = client_send_recv(&msg, CTRL_MSG_SIZE, 1000);
+	g_msg.op = msg_op_login;
+	ret = client_send_recv(&g_msg, CTRL_MSG_SIZE, 1000);
 	if (ret == CTRL_MSG_SIZE)
 		ret = 0;
 
@@ -468,10 +468,10 @@ static int client_run(void)
 	return ret;
 }
 
-static int set_test_opt(char *optarg)
+static int set_test_opt(const char *arg)
 {
-	if (strlen(optarg) == 1) {
-		switch (optarg[0]) {
+	if (strlen(arg) == 1) {
+		switch (arg[0]) {
 		case 's':
 			use_rs = 0;
 			break;
@@ -491,15 +491,15 @@ static int set_test_opt(char *optarg)
 			return -1;
 		}
 	} else {
-		if (!strncasecmp("socket", optarg, 6)) {
+		if (!strncasecmp("socket", arg, 6)) {
 			use_rs = 0;
-		} else if (!strncasecmp("async", optarg, 5)) {
+		} else if (!strncasecmp("async", arg, 5)) {
 			use_async = 1;
-		} else if (!strncasecmp("block", optarg, 5)) {
+		} else if (!strncasecmp("block", arg, 5)) {
 			flags = 0;
-		} else if (!strncasecmp("nonblock", optarg, 8)) {
+		} else if (!strncasecmp("nonblock", arg, 8)) {
 			flags = MSG_DONTWAIT;
-		} else if (!strncasecmp("echo", optarg, 4)) {
+		} else if (!strncasecmp("echo", arg, 4)) {
 			echo = 1;
 		} else {
 			return -1;
diff --git a/providers/mthca/cq.c b/providers/mthca/cq.c
index d71d430c6e28..aa08e065f275 100644
--- a/providers/mthca/cq.c
+++ b/providers/mthca/cq.c
@@ -294,7 +294,6 @@ static inline int mthca_poll_one(struct mthca_cq *cq,
 	struct mthca_cqe *cqe;
 	struct mthca_srq *srq;
 	uint32_t qpn;
-	uint32_t wqe;
 	int wqe_index;
 	int is_error;
 	int is_send;
@@ -339,6 +338,7 @@ static inline int mthca_poll_one(struct mthca_cq *cq,
 		wqe_index = ((ntohl(cqe->wqe) - (*cur_qp)->send_wqe_offset) >> wq->wqe_shift);
 		wc->wr_id = (*cur_qp)->wrid[wqe_index + (*cur_qp)->rq.max];
 	} else if ((*cur_qp)->ibv_qp.srq) {
+		uint32_t wqe;
 		srq = to_msrq((*cur_qp)->ibv_qp.srq);
 		wqe = htonl(cqe->wqe);
 		wq = NULL;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
