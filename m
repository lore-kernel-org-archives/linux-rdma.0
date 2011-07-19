From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 4/7] libibverbs: Update examples for IBoE
Date: Tue, 19 Jul 2011 12:31:32 +0300
Message-ID: <alpine.LRH.2.00.1107191230350.5580@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1107191223460.5580@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1107191223460.5580-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since IBoE requires usage of GRH, update ibv_*_pinpong examples to accept
GIDs. GIDs are given as an index to the local port's table and are exchanged
between the client and the server through the socket connection.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 examples/devinfo.c      |   15 +++++++
 examples/pingpong.c     |   32 +++++++++++++++
 examples/pingpong.h     |    4 ++
 examples/rc_pingpong.c  |   97 ++++++++++++++++++++++++++++++++++++-----------
 examples/srq_pingpong.c |   96 +++++++++++++++++++++++++++++++++++-----------
 examples/uc_pingpong.c  |   97 ++++++++++++++++++++++++++++++++++++-----------
 examples/ud_pingpong.c  |   89 ++++++++++++++++++++++++++++++++-----------
 7 files changed, 342 insertions(+), 88 deletions(-)

diff --git a/examples/devinfo.c b/examples/devinfo.c
index 84f95c7..9c472a0 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -184,6 +184,19 @@ static int print_all_port_gids(struct ibv_context *ctx, uint8_t port_num, int tb
 	return rc;
 }

+static const char *link_layer_str(uint8_t link_layer)
+{
+	switch (link_layer) {
+	case IBV_LINK_LAYER_UNSPECIFIED:
+	case IBV_LINK_LAYER_INFINIBAND:
+		return "IB";
+	case IBV_LINK_LAYER_ETHERNET:
+		return "Ethernet";
+	default:
+		return "Unknown";
+	}
+}
+
 static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 {
 	struct ibv_context *ctx;
@@ -284,6 +297,8 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 		printf("\t\t\tsm_lid:\t\t\t%d\n", port_attr.sm_lid);
 		printf("\t\t\tport_lid:\t\t%d\n", port_attr.lid);
 		printf("\t\t\tport_lmc:\t\t0x%02x\n", port_attr.lmc);
+		printf("\t\t\tlink_layer:\t\t%s\n",
+					link_layer_str(port_attr.link_layer));

 		if (verbose) {
 			printf("\t\t\tmax_msg_sz:\t\t0x%x\n", port_attr.max_msg_sz);
diff --git a/examples/pingpong.c b/examples/pingpong.c
index b916f59..d06ba84 100644
--- a/examples/pingpong.c
+++ b/examples/pingpong.c
@@ -31,6 +31,10 @@
  */

 #include "pingpong.h"
+#include <arpa/inet.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>

 enum ibv_mtu pp_mtu_to_enum(int mtu)
 {
@@ -53,3 +57,31 @@ uint16_t pp_get_local_lid(struct ibv_context *context, int port)

 	return attr.lid;
 }
+
+int pp_get_port_info(struct ibv_context *context, int port,
+		     struct ibv_port_attr *attr)
+{
+	return ibv_query_port(context, port, attr);
+}
+
+void wire_gid_to_gid(const char *wgid, union ibv_gid *gid)
+{
+	char tmp[9];
+	uint32_t v32;
+	int i;
+
+	for (tmp[8] = 0, i = 0; i < 4; ++i) {
+		memcpy(tmp, wgid + i * 8, 8);
+		sscanf(tmp, "%x", &v32);
+		*(uint32_t *)(&gid->raw[i * 4]) = ntohl(v32);
+	}
+}
+
+void gid_to_wire_gid(const union ibv_gid *gid, char wgid[])
+{
+	int i;
+
+	for (i = 0; i < 4; ++i)
+		sprintf(&wgid[i * 8], "%08x",
+				htonl(*(uint32_t *)(gid->raw + i * 4)));
+}
diff --git a/examples/pingpong.h b/examples/pingpong.h
index 71d7c3f..9cdc03e 100644
--- a/examples/pingpong.h
+++ b/examples/pingpong.h
@@ -37,5 +37,9 @@

 enum ibv_mtu pp_mtu_to_enum(int mtu);
 uint16_t pp_get_local_lid(struct ibv_context *context, int port);
+int pp_get_port_info(struct ibv_context *context, int port,
+		     struct ibv_port_attr *attr);
+void wire_gid_to_gid(const char *wgid, union ibv_gid *gid);
+void gid_to_wire_gid(const union ibv_gid *gid, char wgid[]);

 #endif /* IBV_PINGPONG_H */
diff --git a/examples/rc_pingpong.c b/examples/rc_pingpong.c
index fa969e0..0b7f3e0 100644
--- a/examples/rc_pingpong.c
+++ b/examples/rc_pingpong.c
@@ -67,17 +67,19 @@ struct pingpong_context {
 	int			 size;
 	int			 rx_depth;
 	int			 pending;
+	struct ibv_port_attr     portinfo;
 };

 struct pingpong_dest {
 	int lid;
 	int qpn;
 	int psn;
+	union ibv_gid gid;
 };

 static int pp_connect_ctx(struct pingpong_context *ctx, int port, int my_psn,
 			  enum ibv_mtu mtu, int sl,
-			  struct pingpong_dest *dest)
+			  struct pingpong_dest *dest, int sgid_idx)
 {
 	struct ibv_qp_attr attr = {
 		.qp_state		= IBV_QPS_RTR,
@@ -94,6 +96,13 @@ static int pp_connect_ctx(struct pingpong_context *ctx, int port, int my_psn,
 			.port_num	= port
 		}
 	};
+
+	if (dest->gid.global.interface_id) {
+		attr.ah_attr.is_global = 1;
+		attr.ah_attr.grh.hop_limit = 1;
+		attr.ah_attr.grh.dgid = dest->gid;
+		attr.ah_attr.grh.sgid_index = sgid_idx;
+	}
 	if (ibv_modify_qp(ctx->qp, &attr,
 			  IBV_QP_STATE              |
 			  IBV_QP_AV                 |
@@ -135,10 +144,11 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
 		.ai_socktype = SOCK_STREAM
 	};
 	char *service;
-	char msg[sizeof "0000:000000:000000"];
+	char msg[sizeof "0000:000000:000000:00000000000000000000000000000000"];
 	int n;
 	int sockfd = -1;
 	struct pingpong_dest *rem_dest = NULL;
+	char gid[33];

 	if (asprintf(&service, "%d", port) < 0)
 		return NULL;
@@ -169,7 +179,9 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
 		return NULL;
 	}

-	sprintf(msg, "%04x:%06x:%06x", my_dest->lid, my_dest->qpn, my_dest->psn);
+	gid_to_wire_gid(&my_dest->gid, gid);
+	sprintf(msg, "%04x:%06x:%06x:%s", my_dest->lid, my_dest->qpn,
+							my_dest->psn, gid);
 	if (write(sockfd, msg, sizeof msg) != sizeof msg) {
 		fprintf(stderr, "Couldn't send local address\n");
 		goto out;
@@ -187,7 +199,9 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
 	if (!rem_dest)
 		goto out;

-	sscanf(msg, "%x:%x:%x", &rem_dest->lid, &rem_dest->qpn, &rem_dest->psn);
+	sscanf(msg, "%x:%x:%x:%s", &rem_dest->lid, &rem_dest->qpn,
+						&rem_dest->psn, gid);
+	wire_gid_to_gid(gid, &rem_dest->gid);

 out:
 	close(sockfd);
@@ -197,7 +211,8 @@ out:
 static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 						 int ib_port, enum ibv_mtu mtu,
 						 int port, int sl,
-						 const struct pingpong_dest *my_dest)
+						 const struct pingpong_dest *my_dest,
+						 int sgid_idx)
 {
 	struct addrinfo *res, *t;
 	struct addrinfo hints = {
@@ -206,10 +221,11 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 		.ai_socktype = SOCK_STREAM
 	};
 	char *service;
-	char msg[sizeof "0000:000000:000000"];
+	char msg[sizeof "0000:000000:000000:00000000000000000000000000000000"];
 	int n;
 	int sockfd = -1, connfd;
 	struct pingpong_dest *rem_dest = NULL;
+	char gid[33];

 	if (asprintf(&service, "%d", port) < 0)
 		return NULL;
@@ -263,16 +279,22 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 	if (!rem_dest)
 		goto out;

-	sscanf(msg, "%x:%x:%x", &rem_dest->lid, &rem_dest->qpn, &rem_dest->psn);
+	sscanf(msg, "%x:%x:%x:%s", &rem_dest->lid, &rem_dest->qpn,
+							&rem_dest->psn, gid);
+	wire_gid_to_gid(gid, &rem_dest->gid);

-	if (pp_connect_ctx(ctx, ib_port, my_dest->psn, mtu, sl, rem_dest)) {
+	if (pp_connect_ctx(ctx, ib_port, my_dest->psn, mtu, sl, rem_dest,
+								sgid_idx)) {
 		fprintf(stderr, "Couldn't connect to remote QP\n");
 		free(rem_dest);
 		rem_dest = NULL;
 		goto out;
 	}

-	sprintf(msg, "%04x:%06x:%06x", my_dest->lid, my_dest->qpn, my_dest->psn);
+
+	gid_to_wire_gid(&my_dest->gid, gid);
+	sprintf(msg, "%04x:%06x:%06x:%s", my_dest->lid, my_dest->qpn,
+							my_dest->psn, gid);
 	if (write(connfd, msg, sizeof msg) != sizeof msg) {
 		fprintf(stderr, "Couldn't send local address\n");
 		free(rem_dest);
@@ -293,7 +315,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 {
 	struct pingpong_context *ctx;

-	ctx = malloc(sizeof *ctx);
+	ctx = calloc(1, sizeof *ctx);
 	if (!ctx)
 		return NULL;

@@ -306,7 +328,8 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 		return NULL;
 	}

-	memset(ctx->buf, 0, size);
+	/* FIXME memset(ctx->buf, 0, size); */
+	memset(ctx->buf, 0x7b, size);

 	ctx->context = ibv_open_device(ib_dev);
 	if (!ctx->context) {
@@ -481,6 +504,7 @@ static void usage(const char *argv0)
 	printf("  -n, --iters=<iters>    number of exchanges (default 1000)\n");
 	printf("  -l, --sl=<sl>          service level value\n");
 	printf("  -e, --events           sleep on CQ events (default poll)\n");
+	printf("  -g, --gid-idx=<gid index> local port gid index\n");
 }

 int main(int argc, char *argv[])
@@ -504,6 +528,8 @@ int main(int argc, char *argv[])
 	int                      rcnt, scnt;
 	int                      num_cq_events = 0;
 	int                      sl = 0;
+	int			 gidx = -1;
+	char			 gid[33];

 	srand48(getpid() * time(NULL));

@@ -520,10 +546,12 @@ int main(int argc, char *argv[])
 			{ .name = "iters",    .has_arg = 1, .val = 'n' },
 			{ .name = "sl",       .has_arg = 1, .val = 'l' },
 			{ .name = "events",   .has_arg = 0, .val = 'e' },
+			{ .name = "gid-idx",  .has_arg = 1, .val = 'g' },
 			{ 0 }
 		};

-		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:e", long_options, NULL);
+		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:eg:",
+							long_options, NULL);
 		if (c == -1)
 			break;

@@ -576,6 +604,10 @@ int main(int argc, char *argv[])
 			++use_event;
 			break;

+		case 'g':
+			gidx = strtol(optarg, NULL, 0);
+			break;
+
 		default:
 			usage(argv[0]);
 			return 1;
@@ -631,30 +663,50 @@ int main(int argc, char *argv[])
 			return 1;
 		}

-	my_dest.lid = pp_get_local_lid(ctx->context, ib_port);
-	my_dest.qpn = ctx->qp->qp_num;
-	my_dest.psn = lrand48() & 0xffffff;
-	if (!my_dest.lid) {
+
+	if (pp_get_port_info(ctx->context, ib_port, &ctx->portinfo)) {
+		fprintf(stderr, "Couldn't get port info\n");
+		return 1;
+	}
+
+	my_dest.lid = ctx->portinfo.lid;
+	if (ctx->portinfo.link_layer != IBV_LINK_LAYER_ETHERNET &&
+							!my_dest.lid) {
 		fprintf(stderr, "Couldn't get local LID\n");
 		return 1;
 	}

-	printf("  local address:  LID 0x%04x, QPN 0x%06x, PSN 0x%06x\n",
-	       my_dest.lid, my_dest.qpn, my_dest.psn);
+	if (gidx >= 0) {
+		if (ibv_query_gid(ctx->context, ib_port, gidx, &my_dest.gid)) {
+			fprintf(stderr, "can't read sgid of index %d\n", gidx);
+			return 1;
+		}
+	} else
+		memset(&my_dest.gid, 0, sizeof my_dest.gid);
+
+	my_dest.qpn = ctx->qp->qp_num;
+	my_dest.psn = lrand48() & 0xffffff;
+	inet_ntop(AF_INET6, &my_dest.gid, gid, sizeof gid);
+	printf("  local address:  LID 0x%04x, QPN 0x%06x, PSN 0x%06x, GID %s\n",
+	       my_dest.lid, my_dest.qpn, my_dest.psn, gid);
+

 	if (servername)
 		rem_dest = pp_client_exch_dest(servername, port, &my_dest);
 	else
-		rem_dest = pp_server_exch_dest(ctx, ib_port, mtu, port, sl, &my_dest);
+		rem_dest = pp_server_exch_dest(ctx, ib_port, mtu, port, sl,
+								&my_dest, gidx);

 	if (!rem_dest)
 		return 1;

-	printf("  remote address: LID 0x%04x, QPN 0x%06x, PSN 0x%06x\n",
-	       rem_dest->lid, rem_dest->qpn, rem_dest->psn);
+	inet_ntop(AF_INET6, &rem_dest->gid, gid, sizeof gid);
+	printf("  remote address: LID 0x%04x, QPN 0x%06x, PSN 0x%06x, GID %s\n",
+	       rem_dest->lid, rem_dest->qpn, rem_dest->psn, gid);

 	if (servername)
-		if (pp_connect_ctx(ctx, ib_port, my_dest.psn, mtu, sl, rem_dest))
+		if (pp_connect_ctx(ctx, ib_port, my_dest.psn, mtu, sl, rem_dest,
+					gidx))
 			return 1;

 	ctx->pending = PINGPONG_RECV_WRID;
@@ -706,6 +758,7 @@ int main(int argc, char *argv[])
 					fprintf(stderr, "poll CQ failed %d\n", ne);
 					return 1;
 				}
+
 			} while (!use_event && ne < 1);

 			for (i = 0; i < ne; ++i) {
diff --git a/examples/srq_pingpong.c b/examples/srq_pingpong.c
index 1e36c57..298dca4 100644
--- a/examples/srq_pingpong.c
+++ b/examples/srq_pingpong.c
@@ -71,17 +71,19 @@ struct pingpong_context {
 	int			 num_qp;
 	int			 rx_depth;
 	int			 pending[MAX_QP];
+	struct ibv_port_attr	 portinfo;
 };

 struct pingpong_dest {
 	int lid;
 	int qpn;
 	int psn;
+	union ibv_gid gid;
 };

 static int pp_connect_ctx(struct pingpong_context *ctx, int port, enum ibv_mtu mtu,
 			  int sl, const struct pingpong_dest *my_dest,
-			  const struct pingpong_dest *dest)
+			  const struct pingpong_dest *dest, int sgid_idx)
 {
 	int i;

@@ -101,6 +103,13 @@ static int pp_connect_ctx(struct pingpong_context *ctx, int port, enum ibv_mtu m
 				.port_num	= port
 			}
 		};
+
+		if (dest->gid.global.interface_id) {
+			attr.ah_attr.is_global = 1;
+			attr.ah_attr.grh.hop_limit = 1;
+			attr.ah_attr.grh.dgid = dest->gid;
+			attr.ah_attr.grh.sgid_index = sgid_idx;
+		}
 		if (ibv_modify_qp(ctx->qp[i], &attr,
 				  IBV_QP_STATE              |
 				  IBV_QP_AV                 |
@@ -143,12 +152,13 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
 		.ai_socktype = SOCK_STREAM
 	};
 	char *service;
-	char msg[sizeof "0000:000000:000000"];
+	char msg[sizeof "0000:000000:000000:00000000000000000000000000000000"];
 	int n;
 	int r;
 	int i;
 	int sockfd = -1;
 	struct pingpong_dest *rem_dest = NULL;
+	char gid[33];

 	if (asprintf(&service, "%d", port) < 0)
 		return NULL;
@@ -180,7 +190,9 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
 	}

 	for (i = 0; i < MAX_QP; ++i) {
-		sprintf(msg, "%04x:%06x:%06x", my_dest[i].lid, my_dest[i].qpn, my_dest[i].psn);
+		gid_to_wire_gid(&my_dest[i].gid, gid);
+		sprintf(msg, "%04x:%06x:%06x:%s", my_dest[i].lid,
+					my_dest[i].qpn, my_dest[i].psn, gid);
 		if (write(sockfd, msg, sizeof msg) != sizeof msg) {
 			fprintf(stderr, "Couldn't send local address\n");
 			goto out;
@@ -204,8 +216,9 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
 			n += r;
 		}

-		sscanf(msg, "%x:%x:%x",
-		       &rem_dest[i].lid, &rem_dest[i].qpn, &rem_dest[i].psn);
+		sscanf(msg, "%x:%x:%x:%s", &rem_dest[i].lid, &rem_dest[i].qpn,
+							&rem_dest[i].psn, gid);
+		wire_gid_to_gid(gid, &rem_dest[i].gid);
 	}

 	write(sockfd, "done", sizeof "done");
@@ -218,7 +231,8 @@ out:
 static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 						 int ib_port, enum ibv_mtu mtu,
 						 int port, int sl,
-						 const struct pingpong_dest *my_dest)
+						 const struct pingpong_dest *my_dest,
+						 int sgid_idx)
 {
 	struct addrinfo *res, *t;
 	struct addrinfo hints = {
@@ -227,12 +241,13 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 		.ai_socktype = SOCK_STREAM
 	};
 	char *service;
-	char msg[sizeof "0000:000000:000000"];
+	char msg[sizeof "0000:000000:000000:00000000000000000000000000000000"];
 	int n;
 	int r;
 	int i;
 	int sockfd = -1, connfd;
 	struct pingpong_dest *rem_dest = NULL;
+	char gid[33];

 	if (asprintf(&service, "%d", port) < 0)
 		return NULL;
@@ -292,11 +307,13 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 			n += r;
 		}

-		sscanf(msg, "%x:%x:%x",
-		       &rem_dest[i].lid, &rem_dest[i].qpn, &rem_dest[i].psn);
+		sscanf(msg, "%x:%x:%x:%s", &rem_dest[i].lid, &rem_dest[i].qpn,
+							&rem_dest[i].psn, gid);
+		wire_gid_to_gid(gid, &rem_dest[i].gid);
 	}

-	if (pp_connect_ctx(ctx, ib_port, mtu, sl, my_dest, rem_dest)) {
+	if (pp_connect_ctx(ctx, ib_port, mtu, sl, my_dest, rem_dest,
+								sgid_idx)) {
 		fprintf(stderr, "Couldn't connect to remote QP\n");
 		free(rem_dest);
 		rem_dest = NULL;
@@ -304,7 +321,9 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 	}

 	for (i = 0; i < MAX_QP; ++i) {
-		sprintf(msg, "%04x:%06x:%06x", my_dest[i].lid, my_dest[i].qpn, my_dest[i].psn);
+		gid_to_wire_gid(&my_dest[i].gid, gid);
+		sprintf(msg, "%04x:%06x:%06x:%s", my_dest[i].lid,
+					my_dest[i].qpn, my_dest[i].psn, gid);
 		if (write(connfd, msg, sizeof msg) != sizeof msg) {
 			fprintf(stderr, "Couldn't send local address\n");
 			free(rem_dest);
@@ -327,7 +346,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 	struct pingpong_context *ctx;
 	int i;

-	ctx = malloc(sizeof *ctx);
+	ctx = calloc(1, sizeof *ctx);
 	if (!ctx)
 		return NULL;

@@ -551,6 +570,7 @@ static void usage(const char *argv0)
 	printf("  -n, --iters=<iters>    number of exchanges per QP(default 1000)\n");
 	printf("  -l, --sl=<sl>          service level value\n");
 	printf("  -e, --events           sleep on CQ events (default poll)\n");
+	printf("  -g, --gid-idx=<gid index> local port gid index\n");
 }

 int main(int argc, char *argv[])
@@ -578,6 +598,8 @@ int main(int argc, char *argv[])
 	int                      i;
 	int                      num_cq_events = 0;
 	int                      sl = 0;
+	int			 gidx = -1;
+	char			 gid[33];

 	srand48(getpid() * time(NULL));

@@ -595,10 +617,12 @@ int main(int argc, char *argv[])
 			{ .name = "iters",    .has_arg = 1, .val = 'n' },
 			{ .name = "sl",       .has_arg = 1, .val = 'l' },
 			{ .name = "events",   .has_arg = 0, .val = 'e' },
+			{ .name = "gid-idx",  .has_arg = 1, .val = 'g' },
 			{ 0 }
 		};

-		c = getopt_long(argc, argv, "p:d:i:s:m:q:r:n:l:e", long_options, NULL);
+		c = getopt_long(argc, argv, "p:d:i:s:m:q:r:n:l:eg:",
+							long_options, NULL);
 		if (c == -1)
 			break;

@@ -655,6 +679,10 @@ int main(int argc, char *argv[])
 			++use_event;
 			break;

+		case 'g':
+			gidx = strtol(optarg, NULL, 0);
+			break;
+
 		default:
 			usage(argv[0]);
 			return 1;
@@ -722,33 +750,57 @@ int main(int argc, char *argv[])

 	memset(my_dest, 0, sizeof my_dest);

+	if (pp_get_port_info(ctx->context, ib_port, &ctx->portinfo)) {
+		fprintf(stderr, "Couldn't get port info\n");
+		return 1;
+	}
 	for (i = 0; i < num_qp; ++i) {
 		my_dest[i].qpn = ctx->qp[i]->qp_num;
 		my_dest[i].psn = lrand48() & 0xffffff;
-		my_dest[i].lid = pp_get_local_lid(ctx->context, ib_port);
-		if (!my_dest[i].lid) {
+		my_dest[i].lid = ctx->portinfo.lid;
+		if (ctx->portinfo.link_layer != IBV_LINK_LAYER_ETHERNET
+							&& !my_dest[i].lid) {
 			fprintf(stderr, "Couldn't get local LID\n");
 			return 1;
 		}

-		printf("  local address:  LID 0x%04x, QPN 0x%06x, PSN 0x%06x\n",
-		       my_dest[i].lid, my_dest[i].qpn, my_dest[i].psn);
+		if (gidx >= 0) {
+			if (ibv_query_gid(ctx->context, ib_port, gidx,
+							&my_dest[i].gid)) {
+				fprintf(stderr, "Could not get local gid for "
+							"gid index %d\n", gidx);
+				return 1;
+			}
+		} else
+			memset(&my_dest[i].gid, 0, sizeof my_dest[i].gid);
+
+		inet_ntop(AF_INET6, &my_dest[i].gid, gid, sizeof gid);
+		printf("  local address:  LID 0x%04x, QPN 0x%06x, PSN 0x%06x, "
+			"GID %s\n", my_dest[i].lid, my_dest[i].qpn,
+			my_dest[i].psn, gid);
 	}

 	if (servername)
 		rem_dest = pp_client_exch_dest(servername, port, my_dest);
 	else
-		rem_dest = pp_server_exch_dest(ctx, ib_port, mtu, port, sl, my_dest);
+		rem_dest = pp_server_exch_dest(ctx, ib_port, mtu, port, sl,
+								my_dest, gidx);

 	if (!rem_dest)
 		return 1;

-	for (i = 0; i < num_qp; ++i)
-		printf("  remote address: LID 0x%04x, QPN 0x%06x, PSN 0x%06x\n",
-		       rem_dest[i].lid, rem_dest[i].qpn, rem_dest[i].psn);
+	inet_ntop(AF_INET6, &rem_dest->gid, gid, sizeof gid);
+
+	for (i = 0; i < num_qp; ++i) {
+		inet_ntop(AF_INET6, &rem_dest[i].gid, gid, sizeof gid);
+		printf("  remote address: LID 0x%04x, QPN 0x%06x, PSN 0x%06x, "
+			"GID %s\n", rem_dest[i].lid, rem_dest[i].qpn,
+			rem_dest[i].psn, gid);
+	}

 	if (servername)
-		if (pp_connect_ctx(ctx, ib_port, mtu, sl, my_dest, rem_dest))
+		if (pp_connect_ctx(ctx, ib_port, mtu, sl, my_dest, rem_dest,
+									gidx))
 			return 1;

 	if (servername)
diff --git a/examples/uc_pingpong.c b/examples/uc_pingpong.c
index 6f31247..4c3fa32 100644
--- a/examples/uc_pingpong.c
+++ b/examples/uc_pingpong.c
@@ -67,17 +67,19 @@ struct pingpong_context {
 	int			 size;
 	int			 rx_depth;
 	int			 pending;
+	struct ibv_port_attr     portinfo;
 };

 struct pingpong_dest {
 	int lid;
 	int qpn;
 	int psn;
+	union ibv_gid gid;
 };

 static int pp_connect_ctx(struct pingpong_context *ctx, int port, int my_psn,
 			  enum ibv_mtu mtu, int sl,
-			  struct pingpong_dest *dest)
+			  struct pingpong_dest *dest, int sgid_idx)
 {
 	struct ibv_qp_attr attr = {
 		.qp_state		= IBV_QPS_RTR,
@@ -92,6 +94,13 @@ static int pp_connect_ctx(struct pingpong_context *ctx, int port, int my_psn,
 			.port_num	= port
 		}
 	};
+
+	if (dest->gid.global.interface_id) {
+		attr.ah_attr.is_global = 1;
+		attr.ah_attr.grh.hop_limit = 1;
+		attr.ah_attr.grh.dgid = dest->gid;
+		attr.ah_attr.grh.sgid_index = sgid_idx;
+	}
 	if (ibv_modify_qp(ctx->qp, &attr,
 			  IBV_QP_STATE              |
 			  IBV_QP_AV                 |
@@ -123,10 +132,11 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
 		.ai_socktype = SOCK_STREAM
 	};
 	char *service;
-	char msg[sizeof "0000:000000:000000"];
+	char msg[sizeof "0000:000000:000000:00000000000000000000000000000000"];
 	int n;
 	int sockfd = -1;
 	struct pingpong_dest *rem_dest = NULL;
+	char gid[33];

 	if (asprintf(&service, "%d", port) < 0)
 		return NULL;
@@ -157,7 +167,9 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
 		return NULL;
 	}

-	sprintf(msg, "%04x:%06x:%06x", my_dest->lid, my_dest->qpn, my_dest->psn);
+	gid_to_wire_gid(&my_dest->gid, gid);
+	sprintf(msg, "%04x:%06x:%06x:%s", my_dest->lid, my_dest->qpn,
+							my_dest->psn, gid);
 	if (write(sockfd, msg, sizeof msg) != sizeof msg) {
 		fprintf(stderr, "Couldn't send local address\n");
 		goto out;
@@ -175,7 +187,9 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
 	if (!rem_dest)
 		goto out;

-	sscanf(msg, "%x:%x:%x", &rem_dest->lid, &rem_dest->qpn, &rem_dest->psn);
+	sscanf(msg, "%x:%x:%x:%s", &rem_dest->lid, &rem_dest->qpn,
+						&rem_dest->psn, gid);
+	wire_gid_to_gid(gid, &rem_dest->gid);

 out:
 	close(sockfd);
@@ -185,7 +199,8 @@ out:
 static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 						 int ib_port, enum ibv_mtu mtu,
 						 int port, int sl,
-						 const struct pingpong_dest *my_dest)
+						 const struct pingpong_dest *my_dest,
+						 int sgid_idx)
 {
 	struct addrinfo *res, *t;
 	struct addrinfo hints = {
@@ -194,10 +209,11 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 		.ai_socktype = SOCK_STREAM
 	};
 	char *service;
-	char msg[sizeof "0000:000000:000000"];
+	char msg[sizeof "0000:000000:000000:00000000000000000000000000000000"];
 	int n;
 	int sockfd = -1, connfd;
 	struct pingpong_dest *rem_dest = NULL;
+	char gid[33];

 	if (asprintf(&service, "%d", port) < 0)
 		return NULL;
@@ -251,16 +267,22 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 	if (!rem_dest)
 		goto out;

-	sscanf(msg, "%x:%x:%x", &rem_dest->lid, &rem_dest->qpn, &rem_dest->psn);
+	sscanf(msg, "%x:%x:%x:%s", &rem_dest->lid, &rem_dest->qpn,
+							&rem_dest->psn, gid);
+	wire_gid_to_gid(gid, &rem_dest->gid);

-	if (pp_connect_ctx(ctx, ib_port, my_dest->psn, mtu, sl, rem_dest)) {
+	if (pp_connect_ctx(ctx, ib_port, my_dest->psn, mtu, sl, rem_dest,
+								sgid_idx)) {
 		fprintf(stderr, "Couldn't connect to remote QP\n");
 		free(rem_dest);
 		rem_dest = NULL;
 		goto out;
 	}

-	sprintf(msg, "%04x:%06x:%06x", my_dest->lid, my_dest->qpn, my_dest->psn);
+
+	gid_to_wire_gid(&my_dest->gid, gid);
+	sprintf(msg, "%04x:%06x:%06x:%s", my_dest->lid, my_dest->qpn,
+							my_dest->psn, gid);
 	if (write(connfd, msg, sizeof msg) != sizeof msg) {
 		fprintf(stderr, "Couldn't send local address\n");
 		free(rem_dest);
@@ -281,7 +303,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 {
 	struct pingpong_context *ctx;

-	ctx = malloc(sizeof *ctx);
+	ctx = calloc(1, sizeof *ctx);
 	if (!ctx)
 		return NULL;

@@ -294,7 +316,8 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 		return NULL;
 	}

-	memset(ctx->buf, 0, size);
+	/* FIXME memset(ctx->buf, 0, size); */
+	memset(ctx->buf, 0x7b, size);

 	ctx->context = ibv_open_device(ib_dev);
 	if (!ctx->context) {
@@ -469,6 +492,7 @@ static void usage(const char *argv0)
 	printf("  -n, --iters=<iters>    number of exchanges (default 1000)\n");
 	printf("  -l, --sl=<sl>          service level value\n");
 	printf("  -e, --events           sleep on CQ events (default poll)\n");
+	printf("  -g, --gid-idx=<gid index> local port gid index\n");
 }

 int main(int argc, char *argv[])
@@ -492,6 +516,8 @@ int main(int argc, char *argv[])
 	int                      rcnt, scnt;
 	int                      num_cq_events = 0;
 	int                      sl = 0;
+	int			 gidx = -1;
+	char			 gid[33];

 	srand48(getpid() * time(NULL));

@@ -508,10 +534,12 @@ int main(int argc, char *argv[])
 			{ .name = "iters",    .has_arg = 1, .val = 'n' },
 			{ .name = "sl",       .has_arg = 1, .val = 'l' },
 			{ .name = "events",   .has_arg = 0, .val = 'e' },
+			{ .name = "gid-idx",  .has_arg = 1, .val = 'g' },
 			{ 0 }
 		};

-		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:e", long_options, NULL);
+		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:eg:",
+							long_options, NULL);
 		if (c == -1)
 			break;

@@ -564,6 +592,10 @@ int main(int argc, char *argv[])
 			++use_event;
 			break;

+		case 'g':
+			gidx = strtol(optarg, NULL, 0);
+			break;
+
 		default:
 			usage(argv[0]);
 			return 1;
@@ -619,30 +651,50 @@ int main(int argc, char *argv[])
 			return 1;
 		}

-	my_dest.lid = pp_get_local_lid(ctx->context, ib_port);
-	my_dest.qpn = ctx->qp->qp_num;
-	my_dest.psn = lrand48() & 0xffffff;
-	if (!my_dest.lid) {
+
+	if (pp_get_port_info(ctx->context, ib_port, &ctx->portinfo)) {
+		fprintf(stderr, "Couldn't get port info\n");
+		return 1;
+	}
+
+	my_dest.lid = ctx->portinfo.lid;
+	if (ctx->portinfo.link_layer != IBV_LINK_LAYER_ETHERNET &&
+							!my_dest.lid) {
 		fprintf(stderr, "Couldn't get local LID\n");
 		return 1;
 	}

-	printf("  local address:  LID 0x%04x, QPN 0x%06x, PSN 0x%06x\n",
-	       my_dest.lid, my_dest.qpn, my_dest.psn);
+	if (gidx >= 0) {
+		if (ibv_query_gid(ctx->context, ib_port, gidx, &my_dest.gid)) {
+			fprintf(stderr, "can't read sgid of index %d\n", gidx);
+			return 1;
+		}
+	} else
+		memset(&my_dest.gid, 0, sizeof my_dest.gid);
+
+	my_dest.qpn = ctx->qp->qp_num;
+	my_dest.psn = lrand48() & 0xffffff;
+	inet_ntop(AF_INET6, &my_dest.gid, gid, sizeof gid);
+	printf("  local address:  LID 0x%04x, QPN 0x%06x, PSN 0x%06x, GID %s\n",
+	       my_dest.lid, my_dest.qpn, my_dest.psn, gid);
+

 	if (servername)
 		rem_dest = pp_client_exch_dest(servername, port, &my_dest);
 	else
-		rem_dest = pp_server_exch_dest(ctx, ib_port, mtu, port, sl, &my_dest);
+		rem_dest = pp_server_exch_dest(ctx, ib_port, mtu, port, sl,
+								&my_dest, gidx);

 	if (!rem_dest)
 		return 1;

-	printf("  remote address: LID 0x%04x, QPN 0x%06x, PSN 0x%06x\n",
-	       rem_dest->lid, rem_dest->qpn, rem_dest->psn);
+	inet_ntop(AF_INET6, &rem_dest->gid, gid, sizeof gid);
+	printf("  remote address: LID 0x%04x, QPN 0x%06x, PSN 0x%06x, GID %s\n",
+	       rem_dest->lid, rem_dest->qpn, rem_dest->psn, gid);

 	if (servername)
-		if (pp_connect_ctx(ctx, ib_port, my_dest.psn, mtu, sl, rem_dest))
+		if (pp_connect_ctx(ctx, ib_port, my_dest.psn, mtu, sl, rem_dest,
+					gidx))
 			return 1;

 	ctx->pending = PINGPONG_RECV_WRID;
@@ -694,6 +746,7 @@ int main(int argc, char *argv[])
 					fprintf(stderr, "poll CQ failed %d\n", ne);
 					return 1;
 				}
+
 			} while (!use_event && ne < 1);

 			for (i = 0; i < ne; ++i) {
diff --git a/examples/ud_pingpong.c b/examples/ud_pingpong.c
index 6f10212..71b152d 100644
--- a/examples/ud_pingpong.c
+++ b/examples/ud_pingpong.c
@@ -68,16 +68,18 @@ struct pingpong_context {
 	int			 size;
 	int			 rx_depth;
 	int			 pending;
+	struct ibv_port_attr     portinfo;
 };

 struct pingpong_dest {
 	int lid;
 	int qpn;
 	int psn;
+	union ibv_gid gid;
 };

 static int pp_connect_ctx(struct pingpong_context *ctx, int port, int my_psn,
-			  int sl, struct pingpong_dest *dest)
+			  int sl, struct pingpong_dest *dest, int sgid_idx)
 {
 	struct ibv_ah_attr ah_attr = {
 		.is_global     = 0,
@@ -105,6 +107,13 @@ static int pp_connect_ctx(struct pingpong_context *ctx, int port, int my_psn,
 		return 1;
 	}

+	if (dest->gid.global.interface_id) {
+		ah_attr.is_global = 1;
+		ah_attr.grh.hop_limit = 1;
+		ah_attr.grh.dgid = dest->gid;
+		ah_attr.grh.sgid_index = sgid_idx;
+	}
+
 	ctx->ah = ibv_create_ah(ctx->pd, &ah_attr);
 	if (!ctx->ah) {
 		fprintf(stderr, "Failed to create AH\n");
@@ -123,10 +132,11 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
 		.ai_socktype = SOCK_STREAM
 	};
 	char *service;
-	char msg[sizeof "0000:000000:000000"];
+	char msg[sizeof "0000:000000:000000:00000000000000000000000000000000"];
 	int n;
 	int sockfd = -1;
 	struct pingpong_dest *rem_dest = NULL;
+	char gid[33];

 	if (asprintf(&service, "%d", port) < 0)
 		return NULL;
@@ -157,7 +167,9 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
 		return NULL;
 	}

-	sprintf(msg, "%04x:%06x:%06x", my_dest->lid, my_dest->qpn, my_dest->psn);
+	gid_to_wire_gid(&my_dest->gid, gid);
+	sprintf(msg, "%04x:%06x:%06x:%s", my_dest->lid, my_dest->qpn,
+							my_dest->psn, gid);
 	if (write(sockfd, msg, sizeof msg) != sizeof msg) {
 		fprintf(stderr, "Couldn't send local address\n");
 		goto out;
@@ -175,7 +187,9 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
 	if (!rem_dest)
 		goto out;

-	sscanf(msg, "%x:%x:%x", &rem_dest->lid, &rem_dest->qpn, &rem_dest->psn);
+	sscanf(msg, "%x:%x:%x:%s", &rem_dest->lid, &rem_dest->qpn,
+							&rem_dest->psn, gid);
+	wire_gid_to_gid(gid, &rem_dest->gid);

 out:
 	close(sockfd);
@@ -184,7 +198,8 @@ out:

 static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 						 int ib_port, int port, int sl,
-						 const struct pingpong_dest *my_dest)
+						 const struct pingpong_dest *my_dest,
+						 int sgid_idx)
 {
 	struct addrinfo *res, *t;
 	struct addrinfo hints = {
@@ -193,10 +208,11 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 		.ai_socktype = SOCK_STREAM
 	};
 	char *service;
-	char msg[sizeof "0000:000000:000000"];
+	char msg[sizeof "0000:000000:000000:00000000000000000000000000000000"];
 	int n;
 	int sockfd = -1, connfd;
 	struct pingpong_dest *rem_dest = NULL;
+	char gid[33];

 	if (asprintf(&service, "%d", port) < 0)
 		return NULL;
@@ -250,16 +266,21 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
 	if (!rem_dest)
 		goto out;

-	sscanf(msg, "%x:%x:%x", &rem_dest->lid, &rem_dest->qpn, &rem_dest->psn);
+	sscanf(msg, "%x:%x:%x:%s", &rem_dest->lid, &rem_dest->qpn,
+							&rem_dest->psn, gid);
+	wire_gid_to_gid(gid, &rem_dest->gid);

-	if (pp_connect_ctx(ctx, ib_port, my_dest->psn, sl, rem_dest)) {
+	if (pp_connect_ctx(ctx, ib_port, my_dest->psn, sl, rem_dest,
+								sgid_idx)) {
 		fprintf(stderr, "Couldn't connect to remote QP\n");
 		free(rem_dest);
 		rem_dest = NULL;
 		goto out;
 	}

-	sprintf(msg, "%04x:%06x:%06x", my_dest->lid, my_dest->qpn, my_dest->psn);
+	gid_to_wire_gid(&my_dest->gid, gid);
+	sprintf(msg, "%04x:%06x:%06x:%s", my_dest->lid, my_dest->qpn,
+							my_dest->psn, gid);
 	if (write(connfd, msg, sizeof msg) != sizeof msg) {
 		fprintf(stderr, "Couldn't send local address\n");
 		free(rem_dest);
@@ -293,7 +314,8 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 		return NULL;
 	}

-	memset(ctx->buf, 0, size + 40);
+	/* FIXME memset(ctx->buf, 0, size + 40); */
+	memset(ctx->buf, 0x7b, size + 40);

 	ctx->context = ibv_open_device(ib_dev);
 	if (!ctx->context) {
@@ -478,6 +500,7 @@ static void usage(const char *argv0)
 	printf("  -r, --rx-depth=<dep>   number of receives to post at a time (default 500)\n");
 	printf("  -n, --iters=<iters>    number of exchanges (default 1000)\n");
 	printf("  -e, --events           sleep on CQ events (default poll)\n");
+	printf("  -g, --gid-idx=<gid index> local port gid index\n");
 }

 int main(int argc, char *argv[])
@@ -500,6 +523,8 @@ int main(int argc, char *argv[])
 	int                      rcnt, scnt;
 	int                      num_cq_events = 0;
 	int                      sl = 0;
+	int			 gidx = -1;
+	char			 gid[33];

 	srand48(getpid() * time(NULL));

@@ -515,10 +540,12 @@ int main(int argc, char *argv[])
 			{ .name = "iters",    .has_arg = 1, .val = 'n' },
 			{ .name = "sl",       .has_arg = 1, .val = 'l' },
 			{ .name = "events",   .has_arg = 0, .val = 'e' },
+			{ .name = "gid-idx",  .has_arg = 1, .val = 'g' },
 			{ 0 }
 		};

-		c = getopt_long(argc, argv, "p:d:i:s:r:n:l:e", long_options, NULL);
+		c = getopt_long(argc, argv, "p:d:i:s:r:n:l:eg:",
+							long_options, NULL);
 		if (c == -1)
 			break;

@@ -563,6 +590,10 @@ int main(int argc, char *argv[])
 			++use_event;
 			break;

+		case 'g':
+			gidx = strtol(optarg, NULL, 0);
+			break;
+
 		default:
 			usage(argv[0]);
 			return 1;
@@ -618,30 +649,44 @@ int main(int argc, char *argv[])
 			return 1;
 		}

-	my_dest.lid = pp_get_local_lid(ctx->context, ib_port);
-	my_dest.qpn = ctx->qp->qp_num;
-	my_dest.psn = lrand48() & 0xffffff;
-	if (!my_dest.lid) {
-		fprintf(stderr, "Couldn't get local LID\n");
+	if (pp_get_port_info(ctx->context, ib_port, &ctx->portinfo)) {
+		fprintf(stderr, "Couldn't get port info\n");
 		return 1;
 	}
+	my_dest.lid = ctx->portinfo.lid;
+
+	my_dest.qpn = ctx->qp->qp_num;
+	my_dest.psn = lrand48() & 0xffffff;
+
+	if (gidx >= 0) {
+		if (ibv_query_gid(ctx->context, ib_port, gidx, &my_dest.gid)) {
+			fprintf(stderr, "Could not get local gid for gid index "
+								"%d\n", gidx);
+			return 1;
+		}
+	} else
+		memset(&my_dest.gid, 0, sizeof my_dest.gid);

-	printf("  local address:  LID 0x%04x, QPN 0x%06x, PSN 0x%06x\n",
-	       my_dest.lid, my_dest.qpn, my_dest.psn);
+	inet_ntop(AF_INET6, &my_dest.gid, gid, sizeof gid);
+	printf("  local address:  LID 0x%04x, QPN 0x%06x, PSN 0x%06x: GID %s\n",
+	       my_dest.lid, my_dest.qpn, my_dest.psn, gid);

 	if (servername)
 		rem_dest = pp_client_exch_dest(servername, port, &my_dest);
 	else
-		rem_dest = pp_server_exch_dest(ctx, ib_port, port, sl, &my_dest);
+		rem_dest = pp_server_exch_dest(ctx, ib_port, port, sl,
+							&my_dest, gidx);

 	if (!rem_dest)
 		return 1;

-	printf("  remote address: LID 0x%04x, QPN 0x%06x, PSN 0x%06x\n",
-	       rem_dest->lid, rem_dest->qpn, rem_dest->psn);
+	inet_ntop(AF_INET6, &rem_dest->gid, gid, sizeof gid);
+	printf("  remote address: LID 0x%04x, QPN 0x%06x, PSN 0x%06x, GID %s\n",
+	       rem_dest->lid, rem_dest->qpn, rem_dest->psn, gid);

 	if (servername)
-		if (pp_connect_ctx(ctx, ib_port, my_dest.psn, sl, rem_dest))
+		if (pp_connect_ctx(ctx, ib_port, my_dest.psn, sl, rem_dest,
+									gidx))
 			return 1;

 	ctx->pending = PINGPONG_RECV_WRID;
-- 
1.5.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
