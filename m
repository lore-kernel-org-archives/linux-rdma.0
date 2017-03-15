From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 1/6] Use NULL instead of 0 to silence sparse
Date: Wed, 15 Mar 2017 16:12:02 -0600
Message-ID: <1489615927-12117-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1489615927-12117-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489615927-12117-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/examples/rc_pingpong.c   | 2 +-
 libibverbs/examples/srq_pingpong.c  | 2 +-
 libibverbs/examples/uc_pingpong.c   | 2 +-
 libibverbs/examples/ud_pingpong.c   | 2 +-
 libibverbs/examples/xsrq_pingpong.c | 2 +-
 librdmacm/examples/cmatose.c        | 4 ++--
 librdmacm/examples/mckey.c          | 2 +-
 librdmacm/examples/rcopy.c          | 2 +-
 librdmacm/examples/riostream.c      | 2 +-
 librdmacm/examples/rstream.c        | 2 +-
 librdmacm/examples/udaddy.c         | 2 +-
 librdmacm/rsocket.c                 | 2 +-
 rdma-ndd/rdma-ndd.c                 | 6 +++---
 13 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/libibverbs/examples/rc_pingpong.c b/libibverbs/examples/rc_pingpong.c
index 7c70457183d986..7400ec8c80f4b7 100644
--- a/libibverbs/examples/rc_pingpong.c
+++ b/libibverbs/examples/rc_pingpong.c
@@ -274,7 +274,7 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 	}
 
 	listen(sockfd, 1);
-	connfd = accept(sockfd, NULL, 0);
+	connfd = accept(sockfd, NULL, NULL);
 	close(sockfd);
 	if (connfd < 0) {
 		fprintf(stderr, "accept() failed\n");
diff --git a/libibverbs/examples/srq_pingpong.c b/libibverbs/examples/srq_pingpong.c
index 30d81f0e4f316c..59ce0b2e729b8e 100644
--- a/libibverbs/examples/srq_pingpong.c
+++ b/libibverbs/examples/srq_pingpong.c
@@ -284,7 +284,7 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 	}
 
 	listen(sockfd, 1);
-	connfd = accept(sockfd, NULL, 0);
+	connfd = accept(sockfd, NULL, NULL);
 	close(sockfd);
 	if (connfd < 0) {
 		fprintf(stderr, "accept() failed\n");
diff --git a/libibverbs/examples/uc_pingpong.c b/libibverbs/examples/uc_pingpong.c
index 3220cccd633b66..2720ab337de2c4 100644
--- a/libibverbs/examples/uc_pingpong.c
+++ b/libibverbs/examples/uc_pingpong.c
@@ -248,7 +248,7 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 	}
 
 	listen(sockfd, 1);
-	connfd = accept(sockfd, NULL, 0);
+	connfd = accept(sockfd, NULL, NULL);
 	close(sockfd);
 	if (connfd < 0) {
 		fprintf(stderr, "accept() failed\n");
diff --git a/libibverbs/examples/ud_pingpong.c b/libibverbs/examples/ud_pingpong.c
index db783c22375e3a..d6c46f7eda4d53 100644
--- a/libibverbs/examples/ud_pingpong.c
+++ b/libibverbs/examples/ud_pingpong.c
@@ -246,7 +246,7 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 	}
 
 	listen(sockfd, 1);
-	connfd = accept(sockfd, NULL, 0);
+	connfd = accept(sockfd, NULL, NULL);
 	close(sockfd);
 	if (connfd < 0) {
 		fprintf(stderr, "accept() failed\n");
diff --git a/libibverbs/examples/xsrq_pingpong.c b/libibverbs/examples/xsrq_pingpong.c
index 31a86f7c8360e2..46f59a6856a4d5 100644
--- a/libibverbs/examples/xsrq_pingpong.c
+++ b/libibverbs/examples/xsrq_pingpong.c
@@ -633,7 +633,7 @@ static int pp_server_connect(int port)
 	listen(sockfd, ctx.num_clients);
 
 	for (i = 0; i < ctx.num_clients; i++) {
-		connfd = accept(sockfd, NULL, 0);
+		connfd = accept(sockfd, NULL, NULL);
 		if (connfd < 0) {
 			fprintf(stderr, "accept() failed for client %d\n", i);
 			return 1;
diff --git a/librdmacm/examples/cmatose.c b/librdmacm/examples/cmatose.c
index c913c48adbbe05..b1c9dd13e4b15e 100644
--- a/librdmacm/examples/cmatose.c
+++ b/librdmacm/examples/cmatose.c
@@ -119,8 +119,8 @@ static int init_node(struct cmatest_node *node)
 	}
 
 	cqe = message_count ? message_count : 1;
-	node->cq[SEND_CQ_INDEX] = ibv_create_cq(node->cma_id->verbs, cqe, node, 0, 0);
-	node->cq[RECV_CQ_INDEX] = ibv_create_cq(node->cma_id->verbs, cqe, node, 0, 0);
+	node->cq[SEND_CQ_INDEX] = ibv_create_cq(node->cma_id->verbs, cqe, node, NULL, 0);
+	node->cq[RECV_CQ_INDEX] = ibv_create_cq(node->cma_id->verbs, cqe, node, NULL, 0);
 	if (!node->cq[SEND_CQ_INDEX] || !node->cq[RECV_CQ_INDEX]) {
 		ret = -ENOMEM;
 		printf("cmatose: unable to create CQ\n");
diff --git a/librdmacm/examples/mckey.c b/librdmacm/examples/mckey.c
index 7d1b53b025e6e0..60cf8a2408a447 100644
--- a/librdmacm/examples/mckey.c
+++ b/librdmacm/examples/mckey.c
@@ -140,7 +140,7 @@ static int init_node(struct cmatest_node *node)
 	}
 
 	cqe = message_count ? message_count * 2 : 2;
-	node->cq = ibv_create_cq(node->cma_id->verbs, cqe, node, 0, 0);
+	node->cq = ibv_create_cq(node->cma_id->verbs, cqe, node, NULL, 0);
 	if (!node->cq) {
 		ret = -ENOMEM;
 		printf("mckey: unable to create CQ\n");
diff --git a/librdmacm/examples/rcopy.c b/librdmacm/examples/rcopy.c
index 9ff7ade29261a3..c85ce8ee9348b4 100644
--- a/librdmacm/examples/rcopy.c
+++ b/librdmacm/examples/rcopy.c
@@ -278,7 +278,7 @@ static void server_close(int rs, struct msg_hdr *msg)
 
 	if (file_addr) {
 		munmap(file_addr, bytes);
-		file_addr = 0;
+		file_addr = NULL;
 	}
 
 	if (fd > 0) {
diff --git a/librdmacm/examples/riostream.c b/librdmacm/examples/riostream.c
index ac625702ae3342..bdf4fd34edfed6 100644
--- a/librdmacm/examples/riostream.c
+++ b/librdmacm/examples/riostream.c
@@ -422,7 +422,7 @@ static int server_connect(void)
 			}
 		}
 
-		rs = raccept(lrs, NULL, 0);
+		rs = raccept(lrs, NULL, NULL);
 	} while (rs < 0 && (errno == EAGAIN || errno == EWOULDBLOCK));
 	if (rs < 0) {
 		perror("raccept");
diff --git a/librdmacm/examples/rstream.c b/librdmacm/examples/rstream.c
index 4f76005a2651aa..70b714613e91af 100644
--- a/librdmacm/examples/rstream.c
+++ b/librdmacm/examples/rstream.c
@@ -386,7 +386,7 @@ static int server_connect(void)
 			}
 		}
 
-		rs = rs_accept(lrs, NULL, 0);
+		rs = rs_accept(lrs, NULL, NULL);
 	} while (rs < 0 && (errno == EAGAIN || errno == EWOULDBLOCK));
 	if (rs < 0) {
 		perror("raccept");
diff --git a/librdmacm/examples/udaddy.c b/librdmacm/examples/udaddy.c
index 5c984ff615336e..b1ac90c38f3e27 100644
--- a/librdmacm/examples/udaddy.c
+++ b/librdmacm/examples/udaddy.c
@@ -135,7 +135,7 @@ static int init_node(struct cmatest_node *node)
 	}
 
 	cqe = message_count ? message_count * 2 : 2;
-	node->cq = ibv_create_cq(node->cma_id->verbs, cqe, node, 0, 0);
+	node->cq = ibv_create_cq(node->cma_id->verbs, cqe, node, NULL, 0);
 	if (!node->cq) {
 		ret = -ENOMEM;
 		printf("udaddy: unable to create CQ\n");
diff --git a/librdmacm/rsocket.c b/librdmacm/rsocket.c
index db06a9c3b1c5ee..04b91a57b9a42e 100644
--- a/librdmacm/rsocket.c
+++ b/librdmacm/rsocket.c
@@ -2420,7 +2420,7 @@ ssize_t rrecv(int socket, void *buf, size_t len, int flags)
 	rs = idm_at(&idm, socket);
 	if (rs->type == SOCK_DGRAM) {
 		fastlock_acquire(&rs->rlock);
-		ret = ds_recvfrom(rs, buf, len, flags, NULL, 0);
+		ret = ds_recvfrom(rs, buf, len, flags, NULL, NULL);
 		fastlock_release(&rs->rlock);
 		return ret;
 	}
diff --git a/rdma-ndd/rdma-ndd.c b/rdma-ndd/rdma-ndd.c
index 9ac4b8ddf588e9..c598525535b7dc 100644
--- a/rdma-ndd/rdma-ndd.c
+++ b/rdma-ndd/rdma-ndd.c
@@ -291,9 +291,9 @@ int main(int argc, char *argv[])
 	while (1) {
 		int opt_idx = 0;
 		static struct option long_opts[] = {
-			{"foreground",   0, 0, 'f' },
-			{"help",         0, 0, 'h' },
-			{"debug",         0, 0, 'd' },
+			{"foreground",   0, NULL, 'f' },
+			{"help",         0, NULL, 'h' },
+			{"debug",         0, NULL, 'd' },
 			{ }
 		};
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
