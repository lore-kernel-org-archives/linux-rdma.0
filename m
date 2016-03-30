From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 3/3] Add GID support to ibv_xsrq_pingpong example
Date: Wed, 30 Mar 2016 18:39:20 +0300
Message-ID: <1459352360-32663-4-git-send-email-yishaih@mellanox.com>
References: <1459352360-32663-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459352360-32663-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add GID index parameter, it's needed for RoCE.

Signed-off-by: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/pingpong.c      | 10 -------
 examples/pingpong.h      |  1 -
 examples/xsrq_pingpong.c | 72 ++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/examples/pingpong.c b/examples/pingpong.c
index 90732ef..2fe4a04 100644
--- a/examples/pingpong.c
+++ b/examples/pingpong.c
@@ -48,16 +48,6 @@ enum ibv_mtu pp_mtu_to_enum(int mtu)
 	}
 }
 
-uint16_t pp_get_local_lid(struct ibv_context *context, int port)
-{
-	struct ibv_port_attr attr;
-
-	if (ibv_query_port(context, port, &attr))
-		return 0;
-
-	return attr.lid;
-}
-
 int pp_get_port_info(struct ibv_context *context, int port,
 		     struct ibv_port_attr *attr)
 {
diff --git a/examples/pingpong.h b/examples/pingpong.h
index 9cdc03e..8dc5dd0 100644
--- a/examples/pingpong.h
+++ b/examples/pingpong.h
@@ -36,7 +36,6 @@
 #include <infiniband/verbs.h>
 
 enum ibv_mtu pp_mtu_to_enum(int mtu);
-uint16_t pp_get_local_lid(struct ibv_context *context, int port);
 int pp_get_port_info(struct ibv_context *context, int port,
 		     struct ibv_port_attr *attr);
 void wire_gid_to_gid(const char *wgid, union ibv_gid *gid);
diff --git a/examples/xsrq_pingpong.c b/examples/xsrq_pingpong.c
index aadf201..70c5760 100644
--- a/examples/xsrq_pingpong.c
+++ b/examples/xsrq_pingpong.c
@@ -52,17 +52,18 @@
 
 #include "pingpong.h"
 
-#define MSG_FORMAT "%04x:%06x:%06x:%06x:%06x"
-#define MSG_SIZE   33
-#define MSG_SSCAN  "%x:%x:%x:%x:%x"
+#define MSG_FORMAT "%04x:%06x:%06x:%06x:%06x:%32s"
+#define MSG_SIZE   66
+#define MSG_SSCAN  "%x:%x:%x:%x:%x:%s"
 #define ADDR_FORMAT \
-	"%8s: LID %04x, QPN RECV %06x SEND %06x, PSN %06x, SRQN %06x\n"
+	"%8s: LID %04x, QPN RECV %06x SEND %06x, PSN %06x, SRQN %06x, GID %s\n"
 #define TERMINATION_FORMAT "%s"
 #define TERMINATION_MSG_SIZE 4
 #define TERMINATION_MSG "END"
 static int page_size;
 
 struct pingpong_dest {
+	union ibv_gid gid;
 	int lid;
 	int recv_qpn;
 	int send_qpn;
@@ -95,6 +96,7 @@ struct pingpong_context {
 	int			 num_clients;
 	int			 num_tests;
 	int			 use_event;
+	int			 gidx;
 };
 
 struct pingpong_context ctx;
@@ -201,6 +203,7 @@ static int pp_init_ctx(char *ib_devname)
 {
 	struct ibv_srq_init_attr_ex attr;
 	struct ibv_xrcd_init_attr xrcd_attr;
+	struct ibv_port_attr port_attr;
 
 	ctx.recv_qp = calloc(ctx.num_clients, sizeof *ctx.recv_qp);
 	ctx.send_qp = calloc(ctx.num_clients, sizeof *ctx.send_qp);
@@ -213,9 +216,14 @@ static int pp_init_ctx(char *ib_devname)
 		return 1;
 	}
 
-	ctx.lid = pp_get_local_lid(ctx.context, ctx.ib_port);
-	if (ctx.lid < 0) {
-		fprintf(stderr, "Failed to get SLID\n");
+	if (pp_get_port_info(ctx.context, ctx.ib_port, &port_attr)) {
+		fprintf(stderr, "Failed to get port info\n");
+		return 1;
+	}
+
+	ctx.lid = port_attr.lid;
+	if (port_attr.link_layer != IBV_LINK_LAYER_ETHERNET && !ctx.lid) {
+		fprintf(stderr, "Couldn't get local LID\n");
 		return 1;
 	}
 
@@ -378,7 +386,20 @@ static int pp_server_termination()
 static int send_local_dest(int sockfd, int index)
 {
 	char msg[MSG_SIZE];
+	char gid[33];
 	uint32_t srq_num;
+	union ibv_gid local_gid;
+
+	if (ctx.gidx >= 0) {
+		if (ibv_query_gid(ctx.context, ctx.ib_port, ctx.gidx,
+				  &local_gid)) {
+			fprintf(stderr, "can't read sgid of index %d\n",
+				ctx.gidx);
+			return -1;
+		}
+	} else {
+		memset(&local_gid, 0, sizeof(local_gid));
+	}
 
 	ctx.rem_dest[index].recv_psn = lrand48() & 0xffffff;
 	if (ibv_get_srq_num(ctx.srq, &srq_num)) {
@@ -386,13 +407,15 @@ static int send_local_dest(int sockfd, int index)
 		return -1;
 	}
 
+	inet_ntop(AF_INET6, &local_gid, gid, sizeof(gid));
 	printf(ADDR_FORMAT, "local", ctx.lid, ctx.recv_qp[index]->qp_num,
 		ctx.send_qp[index]->qp_num, ctx.rem_dest[index].recv_psn,
-		srq_num);
+		srq_num, gid);
 
+	gid_to_wire_gid(&local_gid, gid);
 	sprintf(msg, MSG_FORMAT, ctx.lid, ctx.recv_qp[index]->qp_num,
 		ctx.send_qp[index]->qp_num, ctx.rem_dest[index].recv_psn,
-		srq_num);
+		srq_num, gid);
 
 	if (write(sockfd, msg, MSG_SIZE) != MSG_SIZE) {
 		fprintf(stderr, "Couldn't send local address\n");
@@ -406,6 +429,7 @@ static int recv_remote_dest(int sockfd, int index)
 {
 	struct pingpong_dest *rem_dest;
 	char msg[MSG_SIZE];
+	char gid[33];
 	int n = 0, r;
 
 	while (n < MSG_SIZE) {
@@ -422,15 +446,27 @@ static int recv_remote_dest(int sockfd, int index)
 
 	rem_dest = &ctx.rem_dest[index];
 	sscanf(msg, MSG_SSCAN, &rem_dest->lid, &rem_dest->recv_qpn,
-	       &rem_dest->send_qpn, &rem_dest->send_psn, &rem_dest->srqn);
+		&rem_dest->send_qpn, &rem_dest->send_psn, &rem_dest->srqn, gid);
 
+	wire_gid_to_gid(gid, &rem_dest->gid);
+	inet_ntop(AF_INET6, &rem_dest->gid, gid, sizeof(gid));
 	printf(ADDR_FORMAT, "remote", rem_dest->lid, rem_dest->recv_qpn,
-	       rem_dest->send_qpn, rem_dest->send_psn, rem_dest->srqn);
+		rem_dest->send_qpn, rem_dest->send_psn, rem_dest->srqn,
+		gid);
 
 	rem_dest->sockfd = sockfd;
 	return 0;
 }
 
+static void set_ah_attr(struct ibv_ah_attr *attr, struct pingpong_context *ctx,
+			int index)
+{
+	attr->is_global = 1;
+	attr->grh.hop_limit = 5;
+	attr->grh.dgid = ctx->rem_dest[index].gid;
+	attr->grh.sgid_index = ctx->gidx;
+}
+
 static int connect_qps(int index)
 {
 	struct ibv_qp_attr attr;
@@ -445,6 +481,9 @@ static int connect_qps(int index)
 	attr.ah_attr.sl	      = ctx.sl;
 	attr.ah_attr.port_num = ctx.ib_port;
 
+	if (ctx.rem_dest[index].gid.global.interface_id)
+		set_ah_attr(&attr.ah_attr, &ctx, index);
+
 	if (ibv_modify_qp(ctx.recv_qp[index], &attr,
 			  IBV_QP_STATE | IBV_QP_AV | IBV_QP_PATH_MTU |
 			  IBV_QP_DEST_QPN | IBV_QP_RQ_PSN |
@@ -473,6 +512,9 @@ static int connect_qps(int index)
 	attr.ah_attr.sl	      = ctx.sl;
 	attr.ah_attr.port_num = ctx.ib_port;
 
+	if (ctx.rem_dest[index].gid.global.interface_id)
+		set_ah_attr(&attr.ah_attr, &ctx, index);
+
 	if (ibv_modify_qp(ctx.send_qp[index], &attr,
 			  IBV_QP_STATE | IBV_QP_AV | IBV_QP_PATH_MTU |
 			  IBV_QP_DEST_QPN | IBV_QP_RQ_PSN)) {
@@ -787,6 +829,7 @@ static void init(void)
 	ctx.num_tests = 5;
 	ctx.mtu = IBV_MTU_2048;
 	ctx.sl = 0;
+	ctx.gidx = -1;
 }
 
 static void usage(const char *argv0)
@@ -805,6 +848,7 @@ static void usage(const char *argv0)
 	printf("  -n, --num_tests=<n>    number of tests per client (default 5)\n");
 	printf("  -l, --sl=<sl>          service level value\n");
 	printf("  -e, --events           sleep on CQ events (default poll)\n");
+	printf("  -g, --gid-idx=<gid index> local port gid index\n");
 }
 
 int main(int argc, char *argv[])
@@ -830,10 +874,11 @@ int main(int argc, char *argv[])
 			{ .name = "num_tests", .has_arg = 1, .val = 'n' },
 			{ .name = "sl",        .has_arg = 1, .val = 'l' },
 			{ .name = "events",    .has_arg = 0, .val = 'e' },
+			{ .name = "gid-idx",   .has_arg = 1, .val = 'g' },
 			{ 0 }
 		};
 
-		c = getopt_long(argc, argv, "p:d:i:s:m:c:n:l:e", long_options,
+		c = getopt_long(argc, argv, "p:d:i:s:m:c:n:l:eg:", long_options,
 				NULL);
 		if (c == -1)
 			break;
@@ -875,6 +920,9 @@ int main(int argc, char *argv[])
 		case 'l':
 			ctx.sl = strtol(optarg, NULL, 0);
 			break;
+		case 'g':
+			ctx.gidx = strtol(optarg, NULL, 0);
+			break;
 		case 'e':
 			ctx.use_event = 1;
 			break;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
