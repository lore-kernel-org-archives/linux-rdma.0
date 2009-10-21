From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm/examples: print errno on failures
Date: Wed, 21 Oct 2009 11:48:43 -0700
Message-ID: <E57E7187D1074CCF8652B7FBC9F63D9B@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Replace printf(... ret) with perror to display the errno value now
that the library sets errno consistently.

This updates the other sample apps similar to the changes Jason
made for rping.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 examples/cmatose.c |   30 +++++++++++++++---------------
 examples/mckey.c   |   12 ++++++------
 examples/udaddy.c  |   20 ++++++++++----------
 3 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/examples/cmatose.c b/examples/cmatose.c
index 75bc478..8c12347 100644
--- a/examples/cmatose.c
+++ b/examples/cmatose.c
@@ -150,7 +150,7 @@ static int init_node(struct cmatest_node *node)
 	init_qp_attr.recv_cq = node->cq[RECV_CQ_INDEX];
 	ret = rdma_create_qp(node->cma_id, node->pd, &init_qp_attr);
 	if (ret) {
-		printf("cmatose: unable to create QP: %d\n", ret);
+		perror("cmatose: unable to create QP");
 		goto out;
 	}
 
@@ -233,12 +233,12 @@ static int addr_handler(struct cmatest_node *node)
 		ret = rdma_set_option(node->cma_id, RDMA_OPTION_ID,
 				      RDMA_OPTION_ID_TOS, &tos, sizeof tos);
 		if (ret)
-			printf("cmatose: set TOS option failed: %d\n", ret);
+			perror("cmatose: set TOS option failed");
 	}
 
 	ret = rdma_resolve_route(node->cma_id, 2000);
 	if (ret) {
-		printf("cmatose: resolve route failed: %d\n", ret);
+		perror("cmatose: resolve route failed");
 		connect_error();
 	}
 	return ret;
@@ -263,7 +263,7 @@ static int route_handler(struct cmatest_node *node)
 	conn_param.retry_count = 5;
 	ret = rdma_connect(node->cma_id, &conn_param);
 	if (ret) {
-		printf("cmatose: failure connecting: %d\n", ret);
+		perror("cmatose: failure connecting");
 		goto err;
 	}
 	return 0;
@@ -300,7 +300,7 @@ static int connect_handler(struct rdma_cm_id *cma_id)
 	conn_param.initiator_depth = 1;
 	ret = rdma_accept(node->cma_id, &conn_param);
 	if (ret) {
-		printf("cmatose: failure accepting: %d\n", ret);
+		perror("cmatose: failure accepting");
 		goto err2;
 	}
 	return 0;
@@ -449,8 +449,8 @@ static int connect_events(void)
 			cma_handler(event->id, event);
 			rdma_ack_cm_event(event);
 		} else {
-			printf("cmatose: failure in rdma_get_cm_event in connect events\n");
-			ret = err;
+			perror("cmatose: failure in rdma_get_cm_event in connect events");
+			ret = errno;
 		}
 	}
 
@@ -468,8 +468,8 @@ static int disconnect_events(void)
 			cma_handler(event->id, event);
 			rdma_ack_cm_event(event);
 		} else {
-			printf("cmatose: failure in rdma_get_cm_event in disconnect events\n");
-			ret = err;
+			perror("cmatose: failure in rdma_get_cm_event in disconnect events");
+			ret = errno;
 		}
 	}
 
@@ -485,7 +485,7 @@ static int migrate_channel(struct rdma_cm_id *listen_id)
 
 	channel = rdma_create_event_channel();
 	if (!channel) {
-		printf("cmatose: failed to create event channel\n");
+		perror("cmatose: failed to create event channel");
 		return -1;
 	}
 
@@ -500,7 +500,7 @@ static int migrate_channel(struct rdma_cm_id *listen_id)
 		rdma_destroy_event_channel(test.channel);
 		test.channel = channel;
 	} else
-		printf("cmatose: failure migrating to channel: %d\n", ret);
+		perror("cmatose: failure migrating to channel");
 
 	return ret;
 }
@@ -535,7 +535,7 @@ static int run_server(void)
 	printf("cmatose: starting server\n");
 	ret = rdma_create_id(test.channel, &listen_id, &test, RDMA_PS_TCP);
 	if (ret) {
-		printf("cmatose: listen request failed\n");
+		perror("cmatose: listen request failed");
 		return ret;
 	}
 
@@ -549,13 +549,13 @@ static int run_server(void)
 	test.src_in.sin_port = port;
 	ret = rdma_bind_addr(listen_id, test.src_addr);
 	if (ret) {
-		printf("cmatose: bind address failed: %d\n", ret);
+		perror("cmatose: bind address failed");
 		goto out;
 	}
 
 	ret = rdma_listen(listen_id, 0);
 	if (ret) {
-		printf("cmatose: failure trying to listen: %d\n", ret);
+		perror("cmatose: failure trying to listen");
 		goto out;
 	}
 
@@ -631,7 +631,7 @@ static int run_client(void)
 					src_addr ? test.src_addr : NULL,
 					test.dst_addr, 2000);
 		if (ret) {
-			printf("cmatose: failure getting addr: %d\n", ret);
+			perror("cmatose: failure getting addr");
 			connect_error();
 			return ret;
 		}
diff --git a/examples/mckey.c b/examples/mckey.c
index 15371b6..467873d 100644
--- a/examples/mckey.c
+++ b/examples/mckey.c
@@ -159,7 +159,7 @@ static int init_node(struct cmatest_node *node)
 	init_qp_attr.recv_cq = node->cq;
 	ret = rdma_create_qp(node->cma_id, node->pd, &init_qp_attr);
 	if (ret) {
-		printf("mckey: unable to create QP: %d\n", ret);
+		perror("mckey: unable to create QP");
 		goto out;
 	}
 
@@ -258,7 +258,7 @@ static int addr_handler(struct cmatest_node *node)
 
 	ret = rdma_join_multicast(node->cma_id, test.dst_addr, node);
 	if (ret) {
-		printf("mckey: failure joining: %d\n", ret);
+		perror("mckey: failure joining");
 		goto err;
 	}
 	return 0;
@@ -452,7 +452,7 @@ static int run(void)
 			ret = rdma_bind_addr(test.nodes[i].cma_id,
 					     test.src_addr);
 			if (ret) {
-				printf("mckey: addr bind failure: %d\n", ret);
+				perror("mckey: addr bind failure");
 				connect_error();
 				return ret;
 			}
@@ -465,7 +465,7 @@ static int run(void)
 						test.src_addr, test.dst_addr,
 						2000);
 		if (ret) {
-			printf("mckey: resolve addr failure: %d\n", ret);
+			perror("mckey: resolve addr failure");
 			connect_error();
 			return ret;
 		}
@@ -502,7 +502,7 @@ out:
 		ret = rdma_leave_multicast(test.nodes[i].cma_id,
 					   test.dst_addr);
 		if (ret)
-			printf("mckey: failure leaving: %d\n", ret);
+			perror("mckey: failure leaving");
 	}
 	return ret;
 }
@@ -561,7 +561,7 @@ int main(int argc, char **argv)
 
 	test.channel = rdma_create_event_channel();
 	if (!test.channel) {
-		printf("failed to create event channel\n");
+		perror("failed to create event channel");
 		exit(1);
 	}
 
diff --git a/examples/udaddy.c b/examples/udaddy.c
index 0d69b05..637306a 100644
--- a/examples/udaddy.c
+++ b/examples/udaddy.c
@@ -158,7 +158,7 @@ static int init_node(struct cmatest_node *node)
 	init_qp_attr.recv_cq = node->cq;
 	ret = rdma_create_qp(node->cma_id, node->pd, &init_qp_attr);
 	if (ret) {
-		printf("udaddy: unable to create QP: %d\n", ret);
+		perror("udaddy: unable to create QP");
 		goto out;
 	}
 
@@ -245,12 +245,12 @@ static int addr_handler(struct cmatest_node *node)
 		ret = rdma_set_option(node->cma_id, RDMA_OPTION_ID,
 				      RDMA_OPTION_ID_TOS, &tos, sizeof tos);
 		if (ret)
-			printf("udaddy: set TOS option failed: %d\n", ret);
+			perror("udaddy: set TOS option failed");
 	}
 
 	ret = rdma_resolve_route(node->cma_id, 2000);
 	if (ret) {
-		printf("udaddy: resolve route failed: %d\n", ret);
+		perror("udaddy: resolve route failed");
 		connect_error();
 	}
 	return ret;
@@ -276,7 +276,7 @@ static int route_handler(struct cmatest_node *node)
 	memset(&conn_param, 0, sizeof conn_param);
 	ret = rdma_connect(node->cma_id, &conn_param);
 	if (ret) {
-		printf("udaddy: failure connecting: %d\n", ret);
+		perror("udaddy: failure connecting");
 		goto err;
 	}
 	return 0;
@@ -316,7 +316,7 @@ static int connect_handler(struct rdma_cm_id *cma_id)
 	conn_param.qp_num = node->cma_id->qp->qp_num;
 	ret = rdma_accept(node->cma_id, &conn_param);
 	if (ret) {
-		printf("udaddy: failure accepting: %d\n", ret);
+		perror("udaddy: failure accepting");
 		goto err2;
 	}
 	node->connected = 1;
@@ -532,7 +532,7 @@ static int run_server(void)
 	printf("udaddy: starting server\n");
 	ret = rdma_create_id(test.channel, &listen_id, &test, port_space);
 	if (ret) {
-		printf("udaddy: listen request failed\n");
+		perror("udaddy: listen request failed");
 		return ret;
 	}
 
@@ -546,13 +546,13 @@ static int run_server(void)
 	test.src_in.sin_port = port;
 	ret = rdma_bind_addr(listen_id, test.src_addr);
 	if (ret) {
-		printf("udaddy: bind address failed: %d\n", ret);
+		perror("udaddy: bind address failed");
 		return ret;
 	}
 
 	ret = rdma_listen(listen_id, 0);
 	if (ret) {
-		printf("udaddy: failure trying to listen: %d\n", ret);
+		perror("udaddy: failure trying to listen");
 		goto out;
 	}
 
@@ -604,7 +604,7 @@ static int run_client(void)
 					src_addr ? test.src_addr : NULL,
 					test.dst_addr, 2000);
 		if (ret) {
-			printf("udaddy: failure getting addr: %d\n", ret);
+			perror("udaddy: failure getting addr");
 			connect_error();
 			return ret;
 		}
@@ -680,7 +680,7 @@ int main(int argc, char **argv)
 
 	test.channel = rdma_create_event_channel();
 	if (!test.channel) {
-		printf("failed to create event channel\n");
+		perror("failed to create event channel");
 		exit(1);
 	}
 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
