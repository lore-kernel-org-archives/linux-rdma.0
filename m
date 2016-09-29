From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [rdma-core] Eliminate GCC warnings
Date: Thu, 29 Sep 2016 11:09:41 -0600
Message-ID: <20160929170941.GD774@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series has already been applied, oops. I sent the pull
request, then got TravisCI working then ran out of time to send to the
list before Doug picked it.

Anyhow, most patches were on the list already in this group, save for
a few for ibacm.

Here are the commits, squashed diff below.

https://github.com/linux-rdma/rdma-core/compare/6f2c2b0021cc35e991808aeb825b7221f9e031b4...ad48f384594facfc73f9b9467c9a4bd33500ba02

If anyone has concerns..

The notable change is this makes TravisCI use -Werror, and runs the
build on 32 bit as well. So all future commits must be warning free on
64/32 bit GCC 6.2 to keep Travis happy.

Jason

 .travis.yml                         |   16 ++++++++-
 ibacm/src/acm.c                     |    9 ++---
 ibacm/src/acme.c                    |    5 +--
 iwpmd/src/iwarp_pm_helper.c         |    2 -
 libhfi1verbs/src/verbs.c            |    2 -
 libi40iw/src/i40iw_uverbs.c         |    6 +--
 libibumad/tests/umad_reg2_compat.c  |    1 
 libibverbs/examples/asyncwatch.c    |    2 -
 libibverbs/examples/pingpong.c      |    2 -
 libibverbs/examples/rc_pingpong.c   |   19 +++++------
 libibverbs/examples/srq_pingpong.c  |   17 +++++++---
 libibverbs/examples/uc_pingpong.c   |   19 +++++------
 libibverbs/examples/ud_pingpong.c   |   21 +++++--------
 libibverbs/examples/xsrq_pingpong.c |    4 +-
 libibverbs/src/neigh.c              |   21 ++++++-------
 libipathverbs/src/verbs.c           |    2 -
 libmlx5/src/verbs.c                 |    4 +-
 libnes/src/nes_uverbs.c             |   21 +++++++------
 libocrdma/src/ocrdma_verbs.c        |    3 +
 librdmacm/examples/cmtime.c         |   16 ---------
 librdmacm/src/acm.c                 |    3 +
 librdmacm/src/rsocket.c             |   58 +++++++++++++++++++++++++-----------
 librxe/src/rxe.c                    |    6 +++
 23 files changed, 146 insertions(+), 113 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index e09dd32ffa9f..a2b9e3b8c3f3 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -21,8 +21,20 @@ addons:
       - pkg-config
       - python
       - valgrind
+
+      # 32 bit support packages
+      - gcc-multilib
+      - lib32gcc-6-dev
 script:
-  - mkdir build
+  - mkdir build build32
   - cd build
-  - CC=gcc-6 cmake -GNinja ..
+  # The goal is warning free compile on latest gcc.
+  - CC=gcc-6 CFLAGS=-Werror cmake -GNinja ..
+  - ninja
+
+  # 32 bit build
+  - cd ../build32
+  # travis's trusty is not configured in a way that enables all32 bit
+  # packages. We could fix this with some sudo stuff.. For now turn off libnl
+  - CC=gcc-6 CFLAGS="-Werror -m32" cmake -GNinja .. -DENABLE_RESOLVE_NEIGH=0
   - ninja
diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index 4650421b81b7..41429e1db4d7 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -218,7 +218,7 @@ static struct sa_data {
 	struct pollfd	*fds;
 	struct acmc_port **ports;
 	int		nfds;
-} sa = { 2000, 2, 1};
+} sa = { 2000, 2, 1, 0, NULL, NULL, 0};
 
 /*
  * Service options - may be set through ibacm_opts.cfg file.
@@ -1402,7 +1402,7 @@ static int acm_nl_send(SOCKET sock, struct acm_msg *msg)
 	int ret;
 	int datalen;
 
-	orig = (struct acm_nl_msg *) msg->hdr.tid;
+	orig = (struct acm_nl_msg *)(uintptr_t)msg->hdr.tid;
 
 	memset(&dst_addr, 0, sizeof(dst_addr));
 	dst_addr.nl_family = AF_NETLINK;
@@ -1562,7 +1562,7 @@ static void acm_nl_process_invalid_request(struct acmc_client *client,
 	msg.hdr.version = ACM_VERSION;
 	msg.hdr.length = ACM_MSG_HDR_LENGTH;
 	msg.hdr.status = ACM_STATUS_EINVAL;
-	msg.hdr.tid = (uint64_t) acmnlmsg;
+	msg.hdr.tid = (uintptr_t) acmnlmsg;
 
 	acm_nl_send(client->sock, &msg);
 }
@@ -1584,7 +1584,7 @@ static void acm_nl_process_resolve(struct acmc_client *client,
 	msg.hdr.version = ACM_VERSION;
 	msg.hdr.length = ACM_MSG_HDR_LENGTH + ACM_MSG_EP_LENGTH;
 	msg.hdr.status = ACM_STATUS_SUCCESS;
-	msg.hdr.tid = (uint64_t) acmnlmsg;
+	msg.hdr.tid = (uintptr_t) acmnlmsg;
 	msg.resolve_data[0].type = ACM_EP_INFO_PATH;
 
 	/* We support only one pathrecord */
@@ -3031,7 +3031,6 @@ static int acm_open_lock_file(void)
 
 	snprintf(pid, sizeof pid, "%d\n", getpid());
 	if (write(lock_fd, pid, strlen(pid)) != strlen(pid)){
-		lockf(lock_fd, F_ULOCK, 0);
 		close(lock_fd);
 		return -1;
 	}
diff --git a/ibacm/src/acme.c b/ibacm/src/acme.c
index 4d9003047506..4b5fe684c8e2 100644
--- a/ibacm/src/acme.c
+++ b/ibacm/src/acme.c
@@ -38,6 +38,7 @@
 #include <getopt.h>
 #include <netdb.h>
 #include <arpa/inet.h>
+#include <inttypes.h>
 
 #include <osd.h>
 #include <infiniband/verbs.h>
@@ -902,7 +903,7 @@ static int enumerate_ep(char *svc, int index)
 		labels = 1;
 	}
 
-	printf("%s,0x%016lx,%d,0x%04x,%d,%s", svc, ep_data->dev_guid,
+	printf("%s,0x%016" PRIx64 ",%d,0x%04x,%d,%s", svc, ep_data->dev_guid,
 	       ep_data->port_num, ep_data->pkey, index, ep_data->prov_name);
 	for (i = 0; i < ep_data->addr_cnt; i++) 
 		printf(",%s", ep_data->addrs[i].name);
@@ -927,7 +928,7 @@ static void enumerate_eps(char *svc)
 static int query_svcs(void)
 {
 	char **svc_list;
-	int ret, i;
+	int ret = -1, i;
 
 	svc_list = parse(svc_arg, NULL);
 	if (!svc_list) {
diff --git a/iwpmd/src/iwarp_pm_helper.c b/iwpmd/src/iwarp_pm_helper.c
index f5c7b96a22e1..89d2b6cef5e6 100644
--- a/iwpmd/src/iwarp_pm_helper.c
+++ b/iwpmd/src/iwarp_pm_helper.c
@@ -82,7 +82,7 @@ iwpm_mapping_request *create_iwpm_map_request(struct nlmsghdr *req_nlh,
 	/* assochandle helps match iwpm request sent to remote peer with future iwpm accept/reject */
 	iwpm_map_req->assochandle = assochandle;
 	if (!assochandle)
-		iwpm_map_req->assochandle = (__u64)iwpm_map_req;
+		iwpm_map_req->assochandle = (uintptr_t)iwpm_map_req;
 
 	memcpy(&iwpm_map_req->src_addr, src_addr, sizeof(struct sockaddr_storage));
 	/* keep record of remote IP address and port */
diff --git a/libhfi1verbs/src/verbs.c b/libhfi1verbs/src/verbs.c
index 854c5676908d..e245ad9e5b4f 100644
--- a/libhfi1verbs/src/verbs.c
+++ b/libhfi1verbs/src/verbs.c
@@ -607,7 +607,7 @@ int hfi1_modify_srq(struct ibv_srq *ibsrq,
 			 (sizeof(struct ibv_sge) * srq->rq.max_sge)) *
 			srq->rq.size;
 	}
-	cmd.offset_addr = (__u64) &offset;
+	cmd.offset_addr = (uintptr_t) &offset;
 	ret = ibv_cmd_modify_srq(ibsrq, attr, attr_mask,
 				 &cmd.ibv_cmd, sizeof cmd);
 	if (ret) {
diff --git a/libi40iw/src/i40iw_uverbs.c b/libi40iw/src/i40iw_uverbs.c
index da23e4c9f413..8369e10f61ee 100644
--- a/libi40iw/src/i40iw_uverbs.c
+++ b/libi40iw/src/i40iw_uverbs.c
@@ -557,7 +557,7 @@ static int i40iw_vmapped_qp(struct i40iw_uqp *iwuqp, struct ibv_pd *pd,
 		return 0;
 	}
 	cmd.user_wqe_buffers = (__u64)((uintptr_t)info->sq);
-	cmd.user_compl_ctx = (u64)&iwuqp->qp;
+	cmd.user_compl_ctx = (uintptr_t)&iwuqp->qp;
 
 	ret = ibv_cmd_create_qp(pd, &iwuqp->ibv_qp, attr, &cmd.ibv_cmd, sizeof(cmd),
 				&resp->ibv_resp, sizeof(struct i40iw_ucreate_qp_resp));
@@ -858,7 +858,7 @@ int i40iw_upost_send(struct ibv_qp *ib_qp, struct ibv_send_wr *ib_wr, struct ibv
 				info.op_type = I40IW_OP_TYPE_SEND;
 
 			if (ib_wr->send_flags & IBV_SEND_INLINE) {
-				info.op.inline_send.data = (void *)ib_wr->sg_list[0].addr;
+			  info.op.inline_send.data = (void *)(uintptr_t)ib_wr->sg_list[0].addr;
 				info.op.inline_send.len = ib_wr->sg_list[0].length;
 				ret = iwuqp->qp.ops.iw_inline_send(&iwuqp->qp, &info,
 								   ib_wr->wr.rdma.rkey, false);
@@ -881,7 +881,7 @@ int i40iw_upost_send(struct ibv_qp *ib_qp, struct ibv_send_wr *ib_wr, struct ibv
 			info.op_type = I40IW_OP_TYPE_RDMA_WRITE;
 
 			if (ib_wr->send_flags & IBV_SEND_INLINE) {
-				info.op.inline_rdma_write.data = (void *)ib_wr->sg_list[0].addr;
+			  info.op.inline_rdma_write.data = (void *)(uintptr_t)ib_wr->sg_list[0].addr;
 				info.op.inline_rdma_write.len = ib_wr->sg_list[0].length;
 				info.op.inline_rdma_write.rem_addr.tag_off = ib_wr->wr.rdma.remote_addr;
 				info.op.inline_rdma_write.rem_addr.len = ib_wr->sg_list->length;
diff --git a/libibumad/tests/umad_reg2_compat.c b/libibumad/tests/umad_reg2_compat.c
index 6dd4a48a59b2..9c239ee4bfae 100644
--- a/libibumad/tests/umad_reg2_compat.c
+++ b/libibumad/tests/umad_reg2_compat.c
@@ -100,7 +100,6 @@ int open_test_device(void)
 
 void test_register(void)
 {
-	int rc = 0;
 	int agent_id;
 	long method_mask[16 / sizeof(long)];
 	uint32_t class_oui = 0x001405; /* OPENIB_OUI */
diff --git a/libibverbs/examples/asyncwatch.c b/libibverbs/examples/asyncwatch.c
index df1261503b7d..c78994d24bed 100644
--- a/libibverbs/examples/asyncwatch.c
+++ b/libibverbs/examples/asyncwatch.c
@@ -105,7 +105,7 @@ int main(int argc, char *argv[])
 		static struct option long_options[] = {
 			{ .name = "ib-dev",    .has_arg = 1, .val = 'd' },
 			{ .name = "help",      .has_arg = 0, .val = 'h' },
-			{ 0 }
+			{}
 		};
 
 		c = getopt_long(argc, argv, "d:h", long_options, NULL);
diff --git a/libibverbs/examples/pingpong.c b/libibverbs/examples/pingpong.c
index 2fe4a04115fb..f6a50e9c62aa 100644
--- a/libibverbs/examples/pingpong.c
+++ b/libibverbs/examples/pingpong.c
@@ -44,7 +44,7 @@ enum ibv_mtu pp_mtu_to_enum(int mtu)
 	case 1024: return IBV_MTU_1024;
 	case 2048: return IBV_MTU_2048;
 	case 4096: return IBV_MTU_4096;
-	default:   return -1;
+	default:   return 0;
 	}
 }
 
diff --git a/libibverbs/examples/rc_pingpong.c b/libibverbs/examples/rc_pingpong.c
index 967678362833..9054a68b7eb5 100644
--- a/libibverbs/examples/rc_pingpong.c
+++ b/libibverbs/examples/rc_pingpong.c
@@ -208,14 +208,13 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
 		goto out;
 	}
 
-	if (read(sockfd, msg, sizeof msg) != sizeof msg) {
-		perror("client read");
-		fprintf(stderr, "Couldn't read remote address\n");
+	if (read(sockfd, msg, sizeof msg) != sizeof msg ||
+	    write(sockfd, "done", sizeof "done") != sizeof "done") {
+		perror("client read/write");
+		fprintf(stderr, "Couldn't read/write remote address\n");
 		goto out;
 	}
 
-	write(sockfd, "done", sizeof "done");
-
 	rem_dest = malloc(sizeof *rem_dest);
 	if (!rem_dest)
 		goto out;
@@ -316,14 +315,14 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 	gid_to_wire_gid(&my_dest->gid, gid);
 	sprintf(msg, "%04x:%06x:%06x:%s", my_dest->lid, my_dest->qpn,
 							my_dest->psn, gid);
-	if (write(connfd, msg, sizeof msg) != sizeof msg) {
-		fprintf(stderr, "Couldn't send local address\n");
+	if (write(connfd, msg, sizeof msg) != sizeof msg ||
+	    read(connfd, msg, sizeof msg) != sizeof msg) {
+		fprintf(stderr, "Couldn't send/recv local address\n");
 		free(rem_dest);
 		rem_dest = NULL;
 		goto out;
 	}
 
-	read(connfd, msg, sizeof msg);
 
 out:
 	close(connfd);
@@ -732,7 +731,7 @@ int main(int argc, char *argv[])
 			{ .name = "gid-idx",  .has_arg = 1, .val = 'g' },
 			{ .name = "odp",      .has_arg = 0, .val = 'o' },
 			{ .name = "ts",       .has_arg = 0, .val = 't' },
-			{ 0 }
+			{}
 		};
 
 		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:eg:ot",
@@ -768,7 +767,7 @@ int main(int argc, char *argv[])
 
 		case 'm':
 			mtu = pp_mtu_to_enum(strtol(optarg, NULL, 0));
-			if (mtu < 0) {
+			if (mtu == 0) {
 				usage(argv[0]);
 				return 1;
 			}
diff --git a/libibverbs/examples/srq_pingpong.c b/libibverbs/examples/srq_pingpong.c
index a1061c31972d..f17972580b57 100644
--- a/libibverbs/examples/srq_pingpong.c
+++ b/libibverbs/examples/srq_pingpong.c
@@ -222,8 +222,10 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
 		wire_gid_to_gid(gid, &rem_dest[i].gid);
 	}
 
-	write(sockfd, "done", sizeof "done");
-
+	if (write(sockfd, "done", sizeof "done") != sizeof "done") {
+		perror("client write");
+		goto out;
+	}
 out:
 	close(sockfd);
 	return rem_dest;
@@ -333,7 +335,12 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 		}
 	}
 
-	read(connfd, msg, sizeof msg);
+	if (read(connfd, msg, sizeof msg) != sizeof msg) {
+		perror("client write");
+		free(rem_dest);
+		rem_dest = NULL;
+		goto out;
+	}
 
 out:
 	close(connfd);
@@ -658,7 +665,7 @@ int main(int argc, char *argv[])
 			{ .name = "sl",       .has_arg = 1, .val = 'l' },
 			{ .name = "events",   .has_arg = 0, .val = 'e' },
 			{ .name = "gid-idx",  .has_arg = 1, .val = 'g' },
-			{ 0 }
+			{}
 		};
 
 		c = getopt_long(argc, argv, "p:d:i:s:m:q:r:n:l:eg:",
@@ -697,7 +704,7 @@ int main(int argc, char *argv[])
 
 		case 'm':
 			mtu = pp_mtu_to_enum(strtol(optarg, NULL, 0));
-			if (mtu < 0) {
+			if (mtu == 0) {
 				usage(argv[0]);
 				return 1;
 			}
diff --git a/libibverbs/examples/uc_pingpong.c b/libibverbs/examples/uc_pingpong.c
index b25d16c79021..7d982d36a5ef 100644
--- a/libibverbs/examples/uc_pingpong.c
+++ b/libibverbs/examples/uc_pingpong.c
@@ -176,13 +176,13 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
 		goto out;
 	}
 
-	if (read(sockfd, msg, sizeof msg) != sizeof msg) {
-		perror("client read");
-		fprintf(stderr, "Couldn't read remote address\n");
+	if (read(sockfd, msg, sizeof msg) != sizeof msg ||
+	    write(sockfd, "done", sizeof "done") != sizeof "done") {
+		perror("client read/write");
+		fprintf(stderr, "Couldn't read/write remote address\n");
 		goto out;
 	}
 
-	write(sockfd, "done", sizeof "done");
 
 	rem_dest = malloc(sizeof *rem_dest);
 	if (!rem_dest)
@@ -284,15 +284,14 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 	gid_to_wire_gid(&my_dest->gid, gid);
 	sprintf(msg, "%04x:%06x:%06x:%s", my_dest->lid, my_dest->qpn,
 							my_dest->psn, gid);
-	if (write(connfd, msg, sizeof msg) != sizeof msg) {
-		fprintf(stderr, "Couldn't send local address\n");
+	if (write(connfd, msg, sizeof msg) != sizeof msg ||
+	    read(connfd, msg, sizeof msg) != sizeof msg) {
+		fprintf(stderr, "Couldn't send/recv local address\n");
 		free(rem_dest);
 		rem_dest = NULL;
 		goto out;
 	}
 
-	read(connfd, msg, sizeof msg);
-
 out:
 	close(connfd);
 	return rem_dest;
@@ -569,7 +568,7 @@ int main(int argc, char *argv[])
 			{ .name = "sl",       .has_arg = 1, .val = 'l' },
 			{ .name = "events",   .has_arg = 0, .val = 'e' },
 			{ .name = "gid-idx",  .has_arg = 1, .val = 'g' },
-			{ 0 }
+			{}
 		};
 
 		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:eg:",
@@ -604,7 +603,7 @@ int main(int argc, char *argv[])
 
 		case 'm':
 			mtu = pp_mtu_to_enum(strtol(optarg, NULL, 0));
-			if (mtu < 0) {
+			if (mtu == 0) {
 				usage(argv[0]);
 				return 1;
 			}
diff --git a/libibverbs/examples/ud_pingpong.c b/libibverbs/examples/ud_pingpong.c
index fa99b9e51dfb..deefb9b81013 100644
--- a/libibverbs/examples/ud_pingpong.c
+++ b/libibverbs/examples/ud_pingpong.c
@@ -176,14 +176,13 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
 		goto out;
 	}
 
-	if (read(sockfd, msg, sizeof msg) != sizeof msg) {
-		perror("client read");
-		fprintf(stderr, "Couldn't read remote address\n");
+	if (read(sockfd, msg, sizeof msg) != sizeof msg ||
+	    write(sockfd, "done", sizeof "done") != sizeof "done") {
+		perror("client read/write");
+		fprintf(stderr, "Couldn't read/write remote address\n");
 		goto out;
 	}
 
-	write(sockfd, "done", sizeof "done");
-
 	rem_dest = malloc(sizeof *rem_dest);
 	if (!rem_dest)
 		goto out;
@@ -282,15 +281,13 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 	gid_to_wire_gid(&my_dest->gid, gid);
 	sprintf(msg, "%04x:%06x:%06x:%s", my_dest->lid, my_dest->qpn,
 							my_dest->psn, gid);
-	if (write(connfd, msg, sizeof msg) != sizeof msg) {
-		fprintf(stderr, "Couldn't send local address\n");
+	if (write(connfd, msg, sizeof msg) != sizeof msg ||
+	    read(connfd, msg, sizeof msg) != sizeof msg) {
+		fprintf(stderr, "Couldn't send/recv local address\n");
 		free(rem_dest);
 		rem_dest = NULL;
 		goto out;
 	}
-
-	read(connfd, msg, sizeof msg);
-
 out:
 	close(connfd);
 	return rem_dest;
@@ -327,7 +324,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 	}
 
 	{
-		struct ibv_port_attr port_info = { 0 };
+		struct ibv_port_attr port_info = {};
 		int mtu;
 
 		if (ibv_query_port(ctx->context, port, &port_info)) {
@@ -591,7 +588,7 @@ int main(int argc, char *argv[])
 			{ .name = "sl",       .has_arg = 1, .val = 'l' },
 			{ .name = "events",   .has_arg = 0, .val = 'e' },
 			{ .name = "gid-idx",  .has_arg = 1, .val = 'g' },
-			{ 0 }
+			{}
 		};
 
 		c = getopt_long(argc, argv, "p:d:i:s:r:n:l:eg:",
diff --git a/libibverbs/examples/xsrq_pingpong.c b/libibverbs/examples/xsrq_pingpong.c
index ff00180f2644..903548ed6824 100644
--- a/libibverbs/examples/xsrq_pingpong.c
+++ b/libibverbs/examples/xsrq_pingpong.c
@@ -875,7 +875,7 @@ int main(int argc, char *argv[])
 			{ .name = "sl",        .has_arg = 1, .val = 'l' },
 			{ .name = "events",    .has_arg = 0, .val = 'e' },
 			{ .name = "gid-idx",   .has_arg = 1, .val = 'g' },
-			{ 0 }
+			{}
 		};
 
 		c = getopt_long(argc, argv, "p:d:i:s:m:c:n:l:eg:", long_options,
@@ -906,7 +906,7 @@ int main(int argc, char *argv[])
 			break;
 		case 'm':
 			ctx.mtu = pp_mtu_to_enum(strtol(optarg, NULL, 0));
-			if (ctx.mtu < 0) {
+			if (ctx.mtu == 0) {
 				usage(argv[0]);
 				return 1;
 			}
diff --git a/libibverbs/src/neigh.c b/libibverbs/src/neigh.c
index 799b810a9ec4..5acfcf06fcde 100644
--- a/libibverbs/src/neigh.c
+++ b/libibverbs/src/neigh.c
@@ -19,6 +19,7 @@
 #include <unistd.h>
 #include <ifaddrs.h>
 #include <netdb.h>
+#include <assert.h>
 #ifndef _LINUX_IF_H
 #include <net/if.h>
 #else
@@ -207,7 +208,7 @@ static int create_socket(struct get_neigh_handler *neigh_handler,
 				    &addr_src.len);
 	if (err) {
 		errno = EADDRNOTAVAIL;
-		return err;
+		return -1;
 	}
 
 	addr_dst->len = sizeof(addr_dst->sktaddr);
@@ -216,24 +217,22 @@ static int create_socket(struct get_neigh_handler *neigh_handler,
 				    &addr_dst->len);
 	if (err) {
 		errno = EADDRNOTAVAIL;
-		return err;
+		return -1;
 	}
 
 	err = set_link_port(&addr_dst->sktaddr, PORT_DISCARD,
 			    neigh_handler->oif);
 	if (err)
-		return err;
+		return -1;
 
 	sock_fd = socket(addr_dst->sktaddr.s.sa_family,
 			 SOCK_DGRAM | SOCK_CLOEXEC, 0);
 	if (sock_fd == -1)
-		return errno ? -errno : -1;
+		return -1;
 	err = bind(sock_fd, &addr_src.sktaddr.s, addr_src.len);
 	if (err) {
-		int bind_err = -errno;
-
 		close(sock_fd);
-		return bind_err ?: EADDRNOTAVAIL;
+		return -1;
 	}
 
 	*psock_fd = sock_fd;
@@ -374,9 +373,11 @@ static struct nl_addr *process_get_neigh_mac(
 
 			if (FD_ISSET(timer_fd, &fdset)) {
 				uint64_t read_val;
+				ssize_t rc;
 
-				(void)read(timer_fd, &read_val,
-					   sizeof(read_val));
+				rc =
+				    read(timer_fd, &read_val, sizeof(read_val));
+				assert(rc == sizeof(read_val));
 				if (++retries >=  NUM_OF_TRIES) {
 					if (!errno)
 						errno = EDESTADDRREQ;
@@ -729,7 +730,7 @@ uint16_t neigh_get_vlan_id_from_dev(struct get_neigh_handler *neigh_handler)
 
 void neigh_set_vlan_id(struct get_neigh_handler *neigh_handler, uint16_t vid)
 {
-	if (vid >= 0 && vid <= 0xfff)
+	if (vid <= 0xfff)
 		neigh_handler->vid = vid;
 }
 
diff --git a/libipathverbs/src/verbs.c b/libipathverbs/src/verbs.c
index 17d54cd4026b..578a38af3428 100644
--- a/libipathverbs/src/verbs.c
+++ b/libipathverbs/src/verbs.c
@@ -583,7 +583,7 @@ int ipath_modify_srq(struct ibv_srq *ibsrq,
 			 (sizeof(struct ibv_sge) * srq->rq.max_sge)) *
 			srq->rq.size;
 	}
-	cmd.offset_addr = (__u64) &offset;
+	cmd.offset_addr = (uintptr_t) &offset;
 	ret = ibv_cmd_modify_srq(ibsrq, attr, attr_mask,
 				 &cmd.ibv_cmd, sizeof cmd);
 	if (ret) {
diff --git a/libmlx5/src/verbs.c b/libmlx5/src/verbs.c
index 52289acc39cc..75cbae35e759 100644
--- a/libmlx5/src/verbs.c
+++ b/libmlx5/src/verbs.c
@@ -1700,8 +1700,8 @@ mlx5_open_xrcd(struct ibv_context *context,
 {
 	int err;
 	struct verbs_xrcd *xrcd;
-	struct ibv_open_xrcd cmd = {0};
-	struct ibv_open_xrcd_resp resp = {0};
+	struct ibv_open_xrcd cmd = {};
+	struct ibv_open_xrcd_resp resp = {};
 
 	xrcd = calloc(1, sizeof(*xrcd));
 	if (!xrcd)
diff --git a/libnes/src/nes_uverbs.c b/libnes/src/nes_uverbs.c
index 80891d6243c7..983d87a80b8b 100644
--- a/libnes/src/nes_uverbs.c
+++ b/libnes/src/nes_uverbs.c
@@ -215,6 +215,7 @@ int nes_udereg_mr(struct ibv_mr *mr)
 	return 0;
 }
 
+#if HAVE_DECL_IBV_QPT_RAW_ETH
 static
 int nes_ima_ureplace_cq(struct ibv_cq *cq,
 			int mcrqf,
@@ -296,6 +297,7 @@ int nes_ima_ureplace_cq(struct ibv_cq *cq,
  err:
 	return ret;
 }
+#endif
 
 /**
  * nes_ucreate_cq
@@ -425,7 +427,6 @@ int nes_ima_upoll_cq(struct ibv_cq *cq, int num_entries, struct ibv_wc *entry)
 	int cqe_count = 0;
 	uint32_t head;
 	uint32_t cq_size;
-	uint16_t qp_size;
 
 	volatile struct nes_hw_nic_cqe *cqe = 0;
 	volatile struct nes_hw_nic_cqe *cqes;
@@ -487,7 +488,6 @@ int nes_ima_upoll_cq(struct ibv_cq *cq, int num_entries, struct ibv_wc *entry)
 			entry->src_qp = nesuqp->qp_id;
 			if (cqe_misc & NES_NIC_CQE_SQ) {
 				entry->opcode = IBV_WC_SEND;
-				qp_size = nesuqp->sq_size;
 
 				entry->wr_id =
 					nesuqp->send_wr_id[nesuqp->sq_tail];
@@ -518,8 +518,8 @@ int nes_ima_upoll_cq(struct ibv_cq *cq, int num_entries, struct ibv_wc *entry)
 				/* Working on a RQ Completion*/
 				if (++nesuqp->rq_tail >= nesuqp->rq_size)
 					nesuqp->rq_tail = 0;
-					if (entry->status == NES_CQ_BUF_OV_ERR)
-						entry->status = IBV_WC_LOC_LEN_ERR;
+				if (entry->status == NES_CQ_BUF_OV_ERR)
+					entry->status = IBV_WC_LOC_LEN_ERR;
 			}
 
 			if (++head >= cq_size)
@@ -557,7 +557,6 @@ int nes_upoll_cq(struct ibv_cq *cq, int num_entries, struct ibv_wc *entry)
 	uint32_t wqe_index;
 	uint32_t wq_tail = 0;
 	struct nes_hw_cqe cqe;
-	uint32_t tmp;
 	uint64_t u64temp;
 	int move_cq_head = 1;
 	uint32_t err_code;
@@ -679,7 +678,6 @@ nes_upoll_cq_update:
 					nesvctx = to_nes_uctx(cq->context);
 				nesvctx->nesupd->udoorbell->cqe_alloc = cpu_to_le32(nesucq->cq_id |
 						(nesucq->polled_completions << 16));
-				tmp = nesvctx->nesupd->udoorbell->cqe_alloc;
 				nesucq->polled_completions = 0;
 			}
 		} else {
@@ -699,7 +697,6 @@ nes_upoll_cq_update:
 			nesvctx = to_nes_uctx(cq->context);
 		nesvctx->nesupd->udoorbell->cqe_alloc = cpu_to_le32(nesucq->cq_id |
 				(nesucq->polled_completions << 16));
-		tmp = nesvctx->nesupd->udoorbell->cqe_alloc;
 		nesucq->polled_completions = 0;
 	}
 	nesucq->head = head;
@@ -1140,7 +1137,6 @@ struct ibv_qp *nes_ucreate_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
 	struct nes_uqp *nesuqp;
 	int	sqdepth, rqdepth;
 	int	 status = 1;
-	int i = 0;
 
 	/* fprintf(stderr, PFX "%s\n", __FUNCTION__); */
 
@@ -1211,6 +1207,8 @@ struct ibv_qp *nes_ucreate_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
 
 #if HAVE_DECL_IBV_QPT_RAW_ETH
 	if (attr->qp_type == IBV_QPT_RAW_ETH) {
+		int i = 0;
+
 		nesuqp->nes_ud_sksq_fd = open("/dev/infiniband/nes_ud_sksq",
 						O_RDWR);
 		if (nesuqp->nes_ud_sksq_fd <= 0)
@@ -1327,7 +1325,6 @@ int nes_udestroy_qp(struct ibv_qp *qp)
 {
 	struct nes_uqp *nesuqp = to_nes_uqp(qp);
 	int ret = 0;
-	int i = 0;
 
 	// fprintf(stderr, PFX "%s addr&mr= %p  \n", __FUNCTION__, &nesuqp->mr );
 
@@ -1353,6 +1350,8 @@ int nes_udestroy_qp(struct ibv_qp *qp)
 
 #if HAVE_DECL_IBV_QPT_RAW_ETH
 	if (qp->qp_type == IBV_QPT_RAW_ETH) {
+		int i = 0;
+
 		if (nesuqp->pend_rx_wr) {
 			for (i = 0; i < NES_UD_RX_BATCH_SZ; i++)
 				if (nesuqp->pend_rx_wr[i].sg_list) {
@@ -1381,6 +1380,7 @@ int nes_udestroy_qp(struct ibv_qp *qp)
 	return 0;
 }
 
+#if HAVE_DECL_IBV_QPT_RAW_ETH
 static inline
 int nes_ima_upost_send(struct ibv_qp *ib_qp, struct ibv_send_wr *ib_wr,
 		struct ibv_send_wr **bad_wr)
@@ -1457,6 +1457,7 @@ int nes_ima_upost_send(struct ibv_qp *ib_qp, struct ibv_send_wr *ib_wr,
 out:
 	return ret;
 }
+#endif
 
 /**
  * nes_upost_send
@@ -1653,6 +1654,7 @@ int nes_upost_send(struct ibv_qp *ib_qp, struct ibv_send_wr *ib_wr,
 	return err;
 }
 
+#if HAVE_DECL_IBV_QPT_RAW_ETH
 static inline
 int nes_ima_upost_recv(struct ibv_qp *ib_qp, struct ibv_recv_wr *ib_wr,
 		struct ibv_recv_wr **bad_wr)
@@ -1727,6 +1729,7 @@ int nes_ima_upost_recv(struct ibv_qp *ib_qp, struct ibv_recv_wr *ib_wr,
 out:
 	return ret;
 }
+#endif
 
 /**
  * nes_upost_recv
diff --git a/libocrdma/src/ocrdma_verbs.c b/libocrdma/src/ocrdma_verbs.c
index 60626260656d..8eb70db2693a 100644
--- a/libocrdma/src/ocrdma_verbs.c
+++ b/libocrdma/src/ocrdma_verbs.c
@@ -945,10 +945,11 @@ static inline void *ocrdma_hwq_head(struct ocrdma_qp_hwq_info *q)
 	return q->va + (q->head * q->entry_size);
 }
 
-static inline void *ocrdma_wq_tail(struct ocrdma_qp_hwq_info *q)
+/*static inline void *ocrdma_wq_tail(struct ocrdma_qp_hwq_info *q)
 {
 	return q->va + (q->tail * q->entry_size);
 }
+*/
 
 static inline void *ocrdma_hwq_head_from_idx(struct ocrdma_qp_hwq_info *q,
 					     uint32_t idx)
diff --git a/librdmacm/examples/cmtime.c b/librdmacm/examples/cmtime.c
index e45980b9bb04..f0b4d0276288 100644
--- a/librdmacm/examples/cmtime.c
+++ b/librdmacm/examples/cmtime.c
@@ -128,13 +128,6 @@ static inline int __list_empty(struct work_list *list)
 	return list->list.next == &list->list;
 }
 
-static inline int list_empty(struct work_list *work_list)
-{
-	pthread_mutex_lock(&work_list->lock);
-	return work_list->list.next == &work_list->list;
-	pthread_mutex_unlock(&work_list->lock);
-}
-
 static inline struct list_head *__list_remove_head(struct work_list *work_list)
 {
 	struct list_head *list_item;
@@ -144,15 +137,6 @@ static inline struct list_head *__list_remove_head(struct work_list *work_list)
 	return list_item;
 }
 
-static inline struct list_head *list_remove_head(struct work_list *work_list)
-{
-	struct list_head *list_item;
-	pthread_mutex_lock(&work_list->lock);
-	list_item = __list_remove_head(work_list);
-	pthread_mutex_unlock(&work_list->lock);
-	return list_item;
-}
-
 static inline void list_add_tail(struct work_list *work_list, struct list_head *req)
 {
 	int empty;
diff --git a/librdmacm/src/acm.c b/librdmacm/src/acm.c
index 75d9d8cf487e..823381aac367 100644
--- a/librdmacm/src/acm.c
+++ b/librdmacm/src/acm.c
@@ -121,7 +121,8 @@ static int ucma_set_server_port(void)
 	FILE *f;
 
 	if ((f = fopen(IBACM_PORT_FILE, "r" STREAM_CLOEXEC))) {
-		fscanf(f, "%" SCNu16, &server_port);
+		if (fscanf(f, "%" SCNu16, &server_port) != 1)
+			server_port = 0;
 		fclose(f);
 	}
 	return server_port;
diff --git a/librdmacm/src/rsocket.c b/librdmacm/src/rsocket.c
index 818505fbe02e..205101f1702f 100644
--- a/librdmacm/src/rsocket.c
+++ b/librdmacm/src/rsocket.c
@@ -404,6 +404,20 @@ struct ds_udp_header {
 
 #define ds_next_qp(qp) container_of((qp)->list.next, struct ds_qp, list)
 
+static void write_all(int fd, const void *msg, size_t len)
+{
+	// FIXME: if fd is a socket this really needs to handle EINTR and other conditions.
+	ssize_t rc = write(fd, msg, len);
+	assert(rc == len);
+}
+
+static void read_all(int fd, void *msg, size_t len)
+{
+	// FIXME: if fd is a socket this really needs to handle EINTR and other conditions.
+	ssize_t rc = read(fd, msg, len);
+	assert(rc == len);
+}
+
 static void ds_insert_qp(struct rsocket *rs, struct ds_qp *qp)
 {
 	if (!rs->qp_list)
@@ -444,8 +458,8 @@ static int rs_notify_svc(struct rs_svc *svc, struct rsocket *rs, int cmd)
 	msg.cmd = cmd;
 	msg.status = EINVAL;
 	msg.rs = rs;
-	write(svc->sock[0], &msg, sizeof msg);
-	read(svc->sock[0], &msg, sizeof msg);
+	write_all(svc->sock[0], &msg, sizeof msg);
+	read_all(svc->sock[0], &msg, sizeof msg);
 	ret = rdma_seterrno(msg.status);
 	if (svc->cnt)
 		goto unlock;
@@ -484,6 +498,15 @@ static int rs_scale_to_value(int value, int bits)
 	       value : (value & ~(1 << (bits - 1))) << bits;
 }
 
+/* gcc > ~5 will not allow (void)fscanf to suppress -Wunused-result, but this
+   will do it.  In this case ignoring the result is OK (but horribly
+   unfriendly to user) since the library has a sane default. */
+#define failable_fscanf(f, fmt, ...)                                           \
+	{                                                                      \
+		int rc = fscanf(f, fmt, __VA_ARGS__);                          \
+		(void) rc;                                                     \
+	}
+
 void rs_configure(void)
 {
 	FILE *f;
@@ -501,27 +524,27 @@ void rs_configure(void)
 	ucma_ib_init();
 
 	if ((f = fopen(RS_CONF_DIR "/polling_time", "r"))) {
-		(void) fscanf(f, "%u", &polling_time);
+		failable_fscanf(f, "%u", &polling_time);
 		fclose(f);
 	}
 
 	if ((f = fopen(RS_CONF_DIR "/inline_default", "r"))) {
-		(void) fscanf(f, "%hu", &def_inline);
+		failable_fscanf(f, "%hu", &def_inline);
 		fclose(f);
 	}
 
 	if ((f = fopen(RS_CONF_DIR "/sqsize_default", "r"))) {
-		(void) fscanf(f, "%hu", &def_sqsize);
+		failable_fscanf(f, "%hu", &def_sqsize);
 		fclose(f);
 	}
 
 	if ((f = fopen(RS_CONF_DIR "/rqsize_default", "r"))) {
-		(void) fscanf(f, "%hu", &def_rqsize);
+		failable_fscanf(f, "%hu", &def_rqsize);
 		fclose(f);
 	}
 
 	if ((f = fopen(RS_CONF_DIR "/mem_default", "r"))) {
-		(void) fscanf(f, "%u", &def_mem);
+		failable_fscanf(f, "%u", &def_mem);
 		fclose(f);
 
 		if (def_mem < 1)
@@ -529,14 +552,14 @@ void rs_configure(void)
 	}
 
 	if ((f = fopen(RS_CONF_DIR "/wmem_default", "r"))) {
-		(void) fscanf(f, "%u", &def_wmem);
+		failable_fscanf(f, "%u", &def_wmem);
 		fclose(f);
 		if (def_wmem < RS_SNDLOWAT)
 			def_wmem = RS_SNDLOWAT << 1;
 	}
 
 	if ((f = fopen(RS_CONF_DIR "/iomap_size", "r"))) {
-		(void) fscanf(f, "%hu", &def_iomap_size);
+		failable_fscanf(f, "%hu", &def_iomap_size);
 		fclose(f);
 
 		/* round to supported values */
@@ -3345,7 +3368,8 @@ static int rs_set_keepalive(struct rsocket *rs, int on)
 	if (on) {
 		if (!rs->keepalive_time) {
 			if ((f = fopen("/proc/sys/net/ipv4/tcp_keepalive_time", "r"))) {
-				(void) fscanf(f, "%u", &rs->keepalive_time);
+				if (fscanf(f, "%u", &rs->keepalive_time) != 1)
+					rs->keepalive_time = 7200;
 				fclose(f);
 			} else {
 				rs->keepalive_time = 7200;
@@ -3985,7 +4009,7 @@ static void udp_svc_process_sock(struct rs_svc *svc)
 {
 	struct rs_svc_msg msg;
 
-	read(svc->sock[1], &msg, sizeof msg);
+	read_all(svc->sock[1], &msg, sizeof msg);
 	switch (msg.cmd) {
 	case RS_SVC_ADD_DGRAM:
 		msg.status = rs_svc_add_rs(svc, msg.rs);
@@ -4009,7 +4033,7 @@ static void udp_svc_process_sock(struct rs_svc *svc)
 		break;
 	}
 
-	write(svc->sock[1], &msg, sizeof msg);
+	write_all(svc->sock[1], &msg, sizeof msg);
 }
 
 static uint8_t udp_svc_sgid_index(struct ds_dest *dest, union ibv_gid *sgid)
@@ -4184,7 +4208,7 @@ static void *udp_svc_run(void *arg)
 	ret = rs_svc_grow_sets(svc, 4);
 	if (ret) {
 		msg.status = ret;
-		write(svc->sock[1], &msg, sizeof msg);
+		write_all(svc->sock[1], &msg, sizeof msg);
 		return (void *) (uintptr_t) ret;
 	}
 
@@ -4222,7 +4246,7 @@ static void tcp_svc_process_sock(struct rs_svc *svc)
 	struct rs_svc_msg msg;
 	int i;
 
-	read(svc->sock[1], &msg, sizeof msg);
+	read_all(svc->sock[1], &msg, sizeof msg);
 	switch (msg.cmd) {
 	case RS_SVC_ADD_KEEPALIVE:
 		msg.status = rs_svc_add_rs(svc, msg.rs);
@@ -4253,7 +4277,7 @@ static void tcp_svc_process_sock(struct rs_svc *svc)
 	default:
 		break;
 	}
-	write(svc->sock[1], &msg, sizeof msg);
+	write_all(svc->sock[1], &msg, sizeof msg);
 }
 
 /*
@@ -4266,7 +4290,7 @@ static void tcp_svc_send_keepalive(struct rsocket *rs)
 	if (rs_ctrl_avail(rs) && (rs->state & rs_connected)) {
 		rs->ctrl_seqno++;
 		rs_post_write(rs, NULL, 0, rs_msg_set(RS_OP_CTRL, RS_CTRL_KEEPALIVE),
-			      0, (uint64_t) NULL, (uint64_t) NULL);
+			      0, (uintptr_t) NULL, (uintptr_t) NULL);
 	}
 	fastlock_release(&rs->cq_lock);
 }	
@@ -4282,7 +4306,7 @@ static void *tcp_svc_run(void *arg)
 	ret = rs_svc_grow_sets(svc, 16);
 	if (ret) {
 		msg.status = ret;
-		write(svc->sock[1], &msg, sizeof msg);
+		write_all(svc->sock[1], &msg, sizeof msg);
 		return (void *) (uintptr_t) ret;
 	}
 
diff --git a/librxe/src/rxe.c b/librxe/src/rxe.c
index 94d0de51f7dd..7164f6627171 100644
--- a/librxe/src/rxe.c
+++ b/librxe/src/rxe.c
@@ -596,6 +596,12 @@ void convert_send_wr(struct rxe_send_wr *kwr, struct ibv_send_wr *uwr)
 		kwr->wr.atomic.swap		= uwr->wr.atomic.swap;
 		kwr->wr.atomic.rkey		= uwr->wr.atomic.rkey;
 		break;
+
+	case IBV_WR_LOCAL_INV:
+	case IBV_WR_BIND_MW:
+	case IBV_WR_SEND_WITH_INV:
+	case IBV_WR_TSO:
+		break;
 	}
 }
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
