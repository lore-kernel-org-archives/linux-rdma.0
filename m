From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Re: [PATCH] rdmaoe/libibverbs: handle binary compatibility
Date: Thu, 10 Dec 2009 23:14:55 +0200
Message-ID: <20091210211455.GA5166@mtls03>
References: <20091210170536.GA3229@mtls03>
	<20091210173353.GW1966@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091210173353.GW1966-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2009 at 10:33:53AM -0700, Jason Gunthorpe wrote:
> Could you prepare this based on Roland's tree? This patch won't apply.
> 

I quote two patches, one for libibverbs based on 74638ac, and the
other for libmlx4 based on 444f634. I changed the padding handling as
you requested for libibverbs. You also need to apply a patch to the
kernel driver to match the new values for link_layer. I put it here
too.

libibverbs:


diff --git a/examples/devinfo.c b/examples/devinfo.c
index 84f95c7..393ec04 100644
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
@@ -284,6 +297,7 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 		printf("\t\t\tsm_lid:\t\t\t%d\n", port_attr.sm_lid);
 		printf("\t\t\tport_lid:\t\t%d\n", port_attr.lid);
 		printf("\t\t\tport_lmc:\t\t0x%02x\n", port_attr.lmc);
+		printf("\t\t\tlink_layer:\t\t%s\n", link_layer_str(port_attr.link_layer));
 
 		if (verbose) {
 			printf("\t\t\tmax_msg_sz:\t\t0x%x\n", port_attr.max_msg_sz);
diff --git a/examples/pingpong.c b/examples/pingpong.c
index b916f59..d4a46e4 100644
--- a/examples/pingpong.c
+++ b/examples/pingpong.c
@@ -31,6 +31,8 @@
  */
 
 #include "pingpong.h"
+#include <arpa/inet.h>
+#include <stdlib.h>
 
 enum ibv_mtu pp_mtu_to_enum(int mtu)
 {
@@ -53,3 +55,10 @@ uint16_t pp_get_local_lid(struct ibv_context *context, int port)
 
 	return attr.lid;
 }
+
+int pp_get_port_info(struct ibv_context *context, int port,
+		     struct ibv_port_attr *attr)
+{
+	return ibv_query_port(context, port, attr);
+}
+
diff --git a/examples/pingpong.h b/examples/pingpong.h
index 71d7c3f..16d3466 100644
--- a/examples/pingpong.h
+++ b/examples/pingpong.h
@@ -37,5 +37,7 @@
 
 enum ibv_mtu pp_mtu_to_enum(int mtu);
 uint16_t pp_get_local_lid(struct ibv_context *context, int port);
+int pp_get_port_info(struct ibv_context *context, int port,
+		     struct ibv_port_attr *attr);
 
 #endif /* IBV_PINGPONG_H */
diff --git a/examples/rc_pingpong.c b/examples/rc_pingpong.c
index fa969e0..4d0bd0d 100644
--- a/examples/rc_pingpong.c
+++ b/examples/rc_pingpong.c
@@ -67,6 +67,8 @@ struct pingpong_context {
 	int			 size;
 	int			 rx_depth;
 	int			 pending;
+	struct ibv_port_attr     portinfo;
+	union ibv_gid		 dgid;
 };
 
 struct pingpong_dest {
@@ -94,6 +96,12 @@ static int pp_connect_ctx(struct pingpong_context *ctx, int port, int my_psn,
 			.port_num	= port
 		}
 	};
+
+	if (ctx->dgid.global.interface_id) {
+		attr.ah_attr.is_global = 1;
+		attr.ah_attr.grh.hop_limit = 1;
+		attr.ah_attr.grh.dgid = ctx->dgid;
+	}
 	if (ibv_modify_qp(ctx->qp, &attr,
 			  IBV_QP_STATE              |
 			  IBV_QP_AV                 |
@@ -289,11 +297,11 @@ out:
 
 static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 					    int rx_depth, int port,
-					    int use_event)
+					    int use_event, int is_server)
 {
 	struct pingpong_context *ctx;
 
-	ctx = malloc(sizeof *ctx);
+	ctx = calloc(1, sizeof *ctx);
 	if (!ctx)
 		return NULL;
 
@@ -306,7 +314,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 		return NULL;
 	}
 
-	memset(ctx->buf, 0, size);
+	memset(ctx->buf, 0x7b + is_server, size);
 
 	ctx->context = ibv_open_device(ib_dev);
 	if (!ctx->context) {
@@ -481,6 +489,7 @@ static void usage(const char *argv0)
 	printf("  -n, --iters=<iters>    number of exchanges (default 1000)\n");
 	printf("  -l, --sl=<sl>          service level value\n");
 	printf("  -e, --events           sleep on CQ events (default poll)\n");
+	printf("  -g, --gid=<remote gid> gid of the other port\n");
 }
 
 int main(int argc, char *argv[])
@@ -504,6 +513,7 @@ int main(int argc, char *argv[])
 	int                      rcnt, scnt;
 	int                      num_cq_events = 0;
 	int                      sl = 0;
+	char			*grh = NULL;
 
 	srand48(getpid() * time(NULL));
 
@@ -520,10 +530,11 @@ int main(int argc, char *argv[])
 			{ .name = "iters",    .has_arg = 1, .val = 'n' },
 			{ .name = "sl",       .has_arg = 1, .val = 'l' },
 			{ .name = "events",   .has_arg = 0, .val = 'e' },
+			{ .name = "gid",      .has_arg = 1, .val = 'g' },
 			{ 0 }
 		};
 
-		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:e", long_options, NULL);
+		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:eg:", long_options, NULL);
 		if (c == -1)
 			break;
 
@@ -576,6 +587,10 @@ int main(int argc, char *argv[])
 			++use_event;
 			break;
 
+		case 'g':
+			grh = strdupa(optarg);
+			break;
+
 		default:
 			usage(argv[0]);
 			return 1;
@@ -615,7 +630,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	ctx = pp_init_ctx(ib_dev, size, rx_depth, ib_port, use_event);
+	ctx = pp_init_ctx(ib_dev, size, rx_depth, ib_port, use_event, !servername);
 	if (!ctx)
 		return 1;
 
@@ -631,17 +646,31 @@ int main(int argc, char *argv[])
 			return 1;
 		}
 
-	my_dest.lid = pp_get_local_lid(ctx->context, ib_port);
-	my_dest.qpn = ctx->qp->qp_num;
-	my_dest.psn = lrand48() & 0xffffff;
-	if (!my_dest.lid) {
-		fprintf(stderr, "Couldn't get local LID\n");
+
+	if (pp_get_port_info(ctx->context, ib_port, &ctx->portinfo)) {
+		fprintf(stderr, "Couldn't get port info\n");
 		return 1;
 	}
 
+	my_dest.lid = ctx->portinfo.lid;
+	if (ctx->portinfo.link_layer == IBV_LINK_LAYER_ETHERNET) {
+		if (!grh) {
+			fprintf(stderr, "Must supply remote gid\n");
+			return 1;
+		}
+		inet_pton(AF_INET6, grh, &ctx->dgid);
+	} else {
+		if (!my_dest.lid) {
+			fprintf(stderr, "Couldn't get local LID\n");
+			return 1;
+		}
+	}
+	my_dest.qpn = ctx->qp->qp_num;
+	my_dest.psn = lrand48() & 0xffffff;
 	printf("  local address:  LID 0x%04x, QPN 0x%06x, PSN 0x%06x\n",
 	       my_dest.lid, my_dest.qpn, my_dest.psn);
 
+
 	if (servername)
 		rem_dest = pp_client_exch_dest(servername, port, &my_dest);
 	else
@@ -706,6 +735,7 @@ int main(int argc, char *argv[])
 					fprintf(stderr, "poll CQ failed %d\n", ne);
 					return 1;
 				}
+
 			} while (!use_event && ne < 1);
 
 			for (i = 0; i < ne; ++i) {
diff --git a/examples/srq_pingpong.c b/examples/srq_pingpong.c
index 1e36c57..eda9013 100644
--- a/examples/srq_pingpong.c
+++ b/examples/srq_pingpong.c
@@ -71,6 +71,8 @@ struct pingpong_context {
 	int			 num_qp;
 	int			 rx_depth;
 	int			 pending[MAX_QP];
+	struct ibv_port_attr	 portinfo;
+	union ibv_gid		 dgid;
 };
 
 struct pingpong_dest {
@@ -101,6 +103,12 @@ static int pp_connect_ctx(struct pingpong_context *ctx, int port, enum ibv_mtu m
 				.port_num	= port
 			}
 		};
+
+		if (ctx->dgid.global.interface_id) {
+			attr.ah_attr.is_global = 1;
+			attr.ah_attr.grh.hop_limit = 1;
+			attr.ah_attr.grh.dgid = ctx->dgid;
+		}
 		if (ibv_modify_qp(ctx->qp[i], &attr,
 				  IBV_QP_STATE              |
 				  IBV_QP_AV                 |
@@ -327,7 +335,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 	struct pingpong_context *ctx;
 	int i;
 
-	ctx = malloc(sizeof *ctx);
+	ctx = calloc(1, sizeof *ctx);
 	if (!ctx)
 		return NULL;
 
@@ -551,6 +559,7 @@ static void usage(const char *argv0)
 	printf("  -n, --iters=<iters>    number of exchanges per QP(default 1000)\n");
 	printf("  -l, --sl=<sl>          service level value\n");
 	printf("  -e, --events           sleep on CQ events (default poll)\n");
+	printf("  -g, --gid=<remote gid> gid of the other port\n");
 }
 
 int main(int argc, char *argv[])
@@ -578,6 +587,7 @@ int main(int argc, char *argv[])
 	int                      i;
 	int                      num_cq_events = 0;
 	int                      sl = 0;
+	char			*grh = NULL;
 
 	srand48(getpid() * time(NULL));
 
@@ -595,10 +605,11 @@ int main(int argc, char *argv[])
 			{ .name = "iters",    .has_arg = 1, .val = 'n' },
 			{ .name = "sl",       .has_arg = 1, .val = 'l' },
 			{ .name = "events",   .has_arg = 0, .val = 'e' },
+			{ .name = "gid",      .has_arg = 1, .val = 'g' },
 			{ 0 }
 		};
 
-		c = getopt_long(argc, argv, "p:d:i:s:m:q:r:n:l:e", long_options, NULL);
+		c = getopt_long(argc, argv, "p:d:i:s:m:q:r:n:l:eg:", long_options, NULL);
 		if (c == -1)
 			break;
 
@@ -655,6 +666,10 @@ int main(int argc, char *argv[])
 			++use_event;
 			break;
 
+		case 'g':
+			grh = strdupa(optarg);
+			break;
+
 		default:
 			usage(argv[0]);
 			return 1;
@@ -722,13 +737,25 @@ int main(int argc, char *argv[])
 
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
-			fprintf(stderr, "Couldn't get local LID\n");
-			return 1;
+		if (ctx->portinfo.link_layer == IBV_LINK_LAYER_ETHERNET) {
+			if (!grh) {
+				fprintf(stderr, "Must supply remote gid\n");
+				return 1;
+			}
+			inet_pton(AF_INET6, grh, &ctx->dgid);
+		} else {
+			my_dest[i].lid = ctx->portinfo.lid;
+			if (!my_dest[i].lid) {
+				fprintf(stderr, "Couldn't get local LID\n");
+				return 1;
+			}
 		}
 
 		printf("  local address:  LID 0x%04x, QPN 0x%06x, PSN 0x%06x\n",
diff --git a/examples/uc_pingpong.c b/examples/uc_pingpong.c
index 6f31247..2bc7da5 100644
--- a/examples/uc_pingpong.c
+++ b/examples/uc_pingpong.c
@@ -67,6 +67,8 @@ struct pingpong_context {
 	int			 size;
 	int			 rx_depth;
 	int			 pending;
+	struct ibv_port_attr	 portinfo;
+	union ibv_gid		 dgid;
 };
 
 struct pingpong_dest {
@@ -92,6 +94,13 @@ static int pp_connect_ctx(struct pingpong_context *ctx, int port, int my_psn,
 			.port_num	= port
 		}
 	};
+
+	if (ctx->dgid.global.interface_id) {
+		attr.ah_attr.is_global = 1;
+		attr.ah_attr.grh.hop_limit = 1;
+		attr.ah_attr.grh.dgid = ctx->dgid;
+	}
+
 	if (ibv_modify_qp(ctx->qp, &attr,
 			  IBV_QP_STATE              |
 			  IBV_QP_AV                 |
@@ -281,7 +290,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 {
 	struct pingpong_context *ctx;
 
-	ctx = malloc(sizeof *ctx);
+	ctx = calloc(1, sizeof *ctx);
 	if (!ctx)
 		return NULL;
 
@@ -469,6 +478,7 @@ static void usage(const char *argv0)
 	printf("  -n, --iters=<iters>    number of exchanges (default 1000)\n");
 	printf("  -l, --sl=<sl>          service level value\n");
 	printf("  -e, --events           sleep on CQ events (default poll)\n");
+	printf("  -g, --gid=<remote gid> gid of the other port\n");
 }
 
 int main(int argc, char *argv[])
@@ -492,6 +502,7 @@ int main(int argc, char *argv[])
 	int                      rcnt, scnt;
 	int                      num_cq_events = 0;
 	int                      sl = 0;
+	char			*grh = NULL;
 
 	srand48(getpid() * time(NULL));
 
@@ -508,10 +519,11 @@ int main(int argc, char *argv[])
 			{ .name = "iters",    .has_arg = 1, .val = 'n' },
 			{ .name = "sl",       .has_arg = 1, .val = 'l' },
 			{ .name = "events",   .has_arg = 0, .val = 'e' },
+			{ .name = "gid",      .has_arg = 1, .val = 'g' },
 			{ 0 }
 		};
 
-		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:e", long_options, NULL);
+		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:eg:", long_options, NULL);
 		if (c == -1)
 			break;
 
@@ -564,6 +576,10 @@ int main(int argc, char *argv[])
 			++use_event;
 			break;
 
+		case 'g':
+			grh = strdupa(optarg);
+			break;
+
 		default:
 			usage(argv[0]);
 			return 1;
@@ -619,14 +635,27 @@ int main(int argc, char *argv[])
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
+	if (ctx->portinfo.link_layer == IBV_LINK_LAYER_ETHERNET) {
+		if (!grh) {
+			fprintf(stderr, "Must supply remote gid\n");
+			return 1;
+		}
+		inet_pton(AF_INET6, grh, &ctx->dgid);
+	} else {
+		if (!my_dest.lid) {
+			fprintf(stderr, "Couldn't get local LID\n");
+			return 1;
+		}
+	}
+	my_dest.qpn = ctx->qp->qp_num;
+	my_dest.psn = lrand48() & 0xffffff;
+
 	printf("  local address:  LID 0x%04x, QPN 0x%06x, PSN 0x%06x\n",
 	       my_dest.lid, my_dest.qpn, my_dest.psn);
 
diff --git a/examples/ud_pingpong.c b/examples/ud_pingpong.c
index 6f10212..e30d6d6 100644
--- a/examples/ud_pingpong.c
+++ b/examples/ud_pingpong.c
@@ -68,6 +68,8 @@ struct pingpong_context {
 	int			 size;
 	int			 rx_depth;
 	int			 pending;
+	struct ibv_port_attr     portinfo;
+	union ibv_gid            dgid;
 };
 
 struct pingpong_dest {
@@ -105,6 +107,12 @@ static int pp_connect_ctx(struct pingpong_context *ctx, int port, int my_psn,
 		return 1;
 	}
 
+	if (ctx->dgid.global.interface_id) {
+		ah_attr.is_global = 1;
+		ah_attr.grh.hop_limit = 1;
+		ah_attr.grh.dgid = ctx->dgid;
+	}
+
 	ctx->ah = ibv_create_ah(ctx->pd, &ah_attr);
 	if (!ctx->ah) {
 		fprintf(stderr, "Failed to create AH\n");
@@ -478,6 +486,7 @@ static void usage(const char *argv0)
 	printf("  -r, --rx-depth=<dep>   number of receives to post at a time (default 500)\n");
 	printf("  -n, --iters=<iters>    number of exchanges (default 1000)\n");
 	printf("  -e, --events           sleep on CQ events (default poll)\n");
+	printf("  -g, --gid              specify remote gid\n");
 }
 
 int main(int argc, char *argv[])
@@ -500,6 +509,7 @@ int main(int argc, char *argv[])
 	int                      rcnt, scnt;
 	int                      num_cq_events = 0;
 	int                      sl = 0;
+	char 			*gid = NULL;
 
 	srand48(getpid() * time(NULL));
 
@@ -515,10 +525,11 @@ int main(int argc, char *argv[])
 			{ .name = "iters",    .has_arg = 1, .val = 'n' },
 			{ .name = "sl",       .has_arg = 1, .val = 'l' },
 			{ .name = "events",   .has_arg = 0, .val = 'e' },
+			{ .name = "gid",      .has_arg = 1, .val = 'g' },
 			{ 0 }
 		};
 
-		c = getopt_long(argc, argv, "p:d:i:s:r:n:l:e", long_options, NULL);
+		c = getopt_long(argc, argv, "p:d:i:s:r:n:l:eg:", long_options, NULL);
 		if (c == -1)
 			break;
 
@@ -563,6 +574,10 @@ int main(int argc, char *argv[])
 			++use_event;
 			break;
 
+		case 'g':
+                        gid = strdupa(optarg);
+			break;
+
 		default:
 			usage(argv[0]);
 			return 1;
@@ -618,12 +633,25 @@ int main(int argc, char *argv[])
 			return 1;
 		}
 
-	my_dest.lid = pp_get_local_lid(ctx->context, ib_port);
+	if (pp_get_port_info(ctx->context, ib_port, &ctx->portinfo)) {
+		fprintf(stderr, "Couldn't get port info\n");
+		return 1;
+	}
+	my_dest.lid = ctx->portinfo.lid;
+
 	my_dest.qpn = ctx->qp->qp_num;
 	my_dest.psn = lrand48() & 0xffffff;
-	if (!my_dest.lid) {
-		fprintf(stderr, "Couldn't get local LID\n");
-		return 1;
+	if (ctx->portinfo.link_layer == IBV_LINK_LAYER_ETHERNET) {
+		if (!my_dest.lid) {
+			fprintf(stderr, "Couldn't get local LID\n");
+			return 1;
+		}
+	} else {
+		if (!gid) {
+			fprintf(stderr, "must specify remote GID\n");
+			return 1;
+		}
+		inet_pton(AF_INET6, gid, &ctx->dgid);
 	}
 
 	printf("  local address:  LID 0x%04x, QPN 0x%06x, PSN 0x%06x\n",
diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 9a81416..8d7c2c6 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -131,6 +131,7 @@ int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
 int ibv_cmd_destroy_ah(struct ibv_ah *ah);
 int ibv_cmd_attach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid);
 int ibv_cmd_detach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid);
+int ibv_cmd_get_mac(struct ibv_pd *pd, uint8_t port, uint8_t *gid, uint8_t *mac);
 
 int ibv_dontfork_range(void *base, size_t size);
 int ibv_dofork_range(void *base, size_t size);
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 0db083a..8ef8844 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -46,7 +46,7 @@
  * The minimum and maximum kernel ABI that we can handle.
  */
 #define IB_USER_VERBS_MIN_ABI_VERSION	1
-#define IB_USER_VERBS_MAX_ABI_VERSION	6
+#define IB_USER_VERBS_MAX_ABI_VERSION	7
 
 enum {
 	IB_USER_VERBS_CMD_GET_CONTEXT,
@@ -85,7 +85,8 @@ enum {
 	IB_USER_VERBS_CMD_MODIFY_SRQ,
 	IB_USER_VERBS_CMD_QUERY_SRQ,
 	IB_USER_VERBS_CMD_DESTROY_SRQ,
-	IB_USER_VERBS_CMD_POST_SRQ_RECV
+	IB_USER_VERBS_CMD_POST_SRQ_RECV,
+	IB_USER_VERBS_CMD_GET_MAC
 };
 
 /*
@@ -223,7 +224,8 @@ struct ibv_query_port_resp {
 	__u8  active_width;
 	__u8  active_speed;
 	__u8  phys_state;
-	__u8  reserved[3];
+	__u8  link_layer;
+	__u8  reserved[2];
 };
 
 struct ibv_alloc_pd {
@@ -798,6 +800,7 @@ enum {
 	IB_USER_VERBS_CMD_QUERY_SRQ_V2,
 	IB_USER_VERBS_CMD_DESTROY_SRQ_V2,
 	IB_USER_VERBS_CMD_POST_SRQ_RECV_V2,
+	IB_USER_VERBS_CMD_GET_MAC_V2 = -1,
 	/*
 	 * Set commands that didn't exist to -1 so our compile-time
 	 * trick opcodes in IBV_INIT_CMD() doesn't break.
@@ -878,4 +881,20 @@ struct ibv_create_srq_resp_v5 {
 	__u32 srq_handle;
 };
 
+struct ibv_get_mac {
+	__u32 command;
+	__u16 in_words;
+	__u16 out_words;
+	__u64 response;
+	__u32 pd_handle;
+	__u8  port;
+	__u8  reserved[3];
+	__u8  dgid[16];
+};
+
+struct ibv_get_mac_resp {
+	__u8	mac[6];
+	__u16	reserved;
+};
+
 #endif /* KERN_ABI_H */
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 0f1cb2e..ecdbc6f 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -38,6 +38,7 @@
 
 #include <stdint.h>
 #include <pthread.h>
+#include <string.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -61,6 +62,7 @@ union ibv_gid {
 		uint64_t	subnet_prefix;
 		uint64_t	interface_id;
 	} global;
+	uint32_t		dwords[4];
 };
 
 enum ibv_node_type {
@@ -161,6 +163,12 @@ enum ibv_port_state {
 	IBV_PORT_ACTIVE_DEFER	= 5
 };
 
+enum {
+	IBV_LINK_LAYER_UNSPECIFIED,
+	IBV_LINK_LAYER_INFINIBAND,
+	IBV_LINK_LAYER_ETHERNET,
+};
+
 struct ibv_port_attr {
 	enum ibv_port_state	state;
 	enum ibv_mtu		max_mtu;
@@ -181,6 +189,8 @@ struct ibv_port_attr {
 	uint8_t			active_width;
 	uint8_t			active_speed;
 	uint8_t			phys_state;
+	uint8_t			link_layer;
+	uint8_t			pad;
 };
 
 enum ibv_event_type {
@@ -693,6 +703,16 @@ struct ibv_context {
 	void		       *abi_compat;
 };
 
+static inline int ___ibv_query_port(struct ibv_context *context,
+				    uint8_t port_num,
+				    struct ibv_port_attr *port_attr)
+{
+	port_attr->link_layer = IBV_LINK_LAYER_UNSPECIFIED;
+	port_attr->pad = 0;
+
+	return context->ops.query_port(context, port_num, port_attr);
+}
+
 /**
  * ibv_get_device_list - Get list of IB devices currently available
  * @num_devices: optional.  if non-NULL, set to the number of devices
@@ -1097,4 +1117,7 @@ END_C_DECLS
 
 #  undef __attribute_const
 
+#define ibv_query_port(context, port_num, port_attr) \
+	___ibv_query_port(context, port_num, port_attr)
+
 #endif /* INFINIBAND_VERBS_H */
diff --git a/src/cmd.c b/src/cmd.c
index cbd5288..5183d59 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -162,6 +162,7 @@ int ibv_cmd_query_device(struct ibv_context *context,
 	return 0;
 }
 
+#include <stdio.h>
 int ibv_cmd_query_port(struct ibv_context *context, uint8_t port_num,
 		       struct ibv_port_attr *port_attr,
 		       struct ibv_query_port *cmd, size_t cmd_size)
@@ -196,6 +197,7 @@ int ibv_cmd_query_port(struct ibv_context *context, uint8_t port_num,
 	port_attr->active_width    = resp.active_width;
 	port_attr->active_speed    = resp.active_speed;
 	port_attr->phys_state      = resp.phys_state;
+	port_attr->link_layer      = resp.link_layer;
 
 	return 0;
 }
@@ -1122,3 +1124,22 @@ int ibv_cmd_detach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t l
 
 	return 0;
 }
+
+int ibv_cmd_get_mac(struct ibv_pd *pd, uint8_t port, uint8_t *gid, uint8_t *mac)
+{
+	struct ibv_get_mac cmd;
+	struct ibv_get_mac_resp resp;
+
+	IBV_INIT_CMD_RESP(&cmd, sizeof cmd, GET_MAC, &resp, sizeof resp);
+	memcpy(cmd.dgid, gid, sizeof cmd.dgid);
+	cmd.pd_handle = pd->handle;
+	cmd.port = port;
+
+	if (write(pd->context->cmd_fd, &cmd, sizeof cmd) != sizeof cmd)
+		return errno;
+
+	memcpy(mac, resp.mac, 6);
+
+	return 0;
+}
+
diff --git a/src/libibverbs.map b/src/libibverbs.map
index 1827da0..1688e73 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -64,6 +64,7 @@ IBVERBS_1.0 {
 		ibv_cmd_destroy_ah;
 		ibv_cmd_attach_mcast;
 		ibv_cmd_detach_mcast;
+		ibv_cmd_get_mac;
 		ibv_copy_qp_attr_from_kern;
 		ibv_copy_path_rec_from_kern;
 		ibv_copy_path_rec_to_kern;
diff --git a/src/verbs.c b/src/verbs.c
index ba3c0a4..2b175b6 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -86,6 +86,7 @@ default_symver(__ibv_query_device, ibv_query_device);
 int __ibv_query_port(struct ibv_context *context, uint8_t port_num,
 		     struct ibv_port_attr *port_attr)
 {
+	port_attr->link_layer = IBV_LINK_LAYER_UNSPECIFIED;
 	return context->ops.query_port(context, port_num, port_attr);
 }
 default_symver(__ibv_query_port, ibv_query_port);



libmlx4:


diff --git a/src/mlx4.h b/src/mlx4.h
index 4445998..661255b 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -236,11 +236,14 @@ struct mlx4_av {
 	uint8_t				hop_limit;
 	uint32_t			sl_tclass_flowlabel;
 	uint8_t				dgid[16];
+	uint8_t				mac[8];
 };
 
 struct mlx4_ah {
 	struct ibv_ah			ibv_ah;
 	struct mlx4_av			av;
+	uint16_t			vlan;
+	uint8_t				mac[6];
 };
 
 static inline unsigned long align(unsigned long val, unsigned long align)
diff --git a/src/qp.c b/src/qp.c
index d194ae3..cd8fab0 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -143,6 +143,8 @@ static void set_datagram_seg(struct mlx4_wqe_datagram_seg *dseg,
 	memcpy(dseg->av, &to_mah(wr->wr.ud.ah)->av, sizeof (struct mlx4_av));
 	dseg->dqpn = htonl(wr->wr.ud.remote_qpn);
 	dseg->qkey = htonl(wr->wr.ud.remote_qkey);
+	dseg->vlan = htons(to_mah(wr->wr.ud.ah)->vlan);
+	memcpy(dseg->mac, to_mah(wr->wr.ud.ah)->mac, 6);
 }
 
 static void __set_data_seg(struct mlx4_wqe_data_seg *dseg, struct ibv_sge *sg)
diff --git a/src/verbs.c b/src/verbs.c
index 1ac1362..667ef68 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -614,9 +614,21 @@ int mlx4_destroy_qp(struct ibv_qp *ibqp)
 	return 0;
 }
 
+static int mcast_mac(uint8_t *mac)
+{
+	int i;
+	uint8_t val = 0xff;
+
+	for (i = 0; i < 6; ++i)
+		val &= mac[i];
+
+	return val == 0xff;
+}
+
 struct ibv_ah *mlx4_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 {
 	struct mlx4_ah *ah;
+	struct ibv_port_attr port_attr;
 
 	ah = malloc(sizeof *ah);
 	if (!ah)
@@ -642,7 +654,24 @@ struct ibv_ah *mlx4_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 		memcpy(ah->av.dgid, attr->grh.dgid.raw, 16);
 	}
 
+	if (ibv_query_port(pd->context, attr->port_num, &port_attr))
+		goto err;
+
+	if (port_attr.link_layer == IBV_LINK_LAYER_ETHERNET) {
+		if (ibv_cmd_get_mac(pd, attr->port_num, ah->av.dgid, ah->mac))
+			goto err;
+
+		ah->vlan = 0;
+		if (mcast_mac(ah->mac))
+			ah->av.dlid = htons(0xc000);
+
+	}
+
+
 	return &ah->ibv_ah;
+err:
+	free(ah);
+	return NULL;
 }
 
 int mlx4_destroy_ah(struct ibv_ah *ah)
diff --git a/src/wqe.h b/src/wqe.h
index 6f7f309..bbd22ba 100644
--- a/src/wqe.h
+++ b/src/wqe.h
@@ -78,7 +78,8 @@ struct mlx4_wqe_datagram_seg {
 	uint32_t		av[8];
 	uint32_t		dqpn;
 	uint32_t		qkey;
-	uint32_t		reserved[2];
+	uint16_t		vlan;
+	uint8_t			mac[6];
 };
 
 struct mlx4_wqe_data_seg {


kernel driver:

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 012aadf..d592bd2 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -452,7 +452,8 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	resp.active_width    = attr.active_width;
 	resp.active_speed    = attr.active_speed;
 	resp.phys_state      = attr.phys_state;
-	resp.transport	     = attr.transport;
+	resp.transport	     = attr.transport == RDMA_TRANSPORT_RDMAOE ?
+		IB_LINK_LAYER_ETHERNET : IB_LINK_LAYER_INFINIBAND;
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index bf6e860..57653b7 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -73,6 +73,12 @@ enum rdma_transport_type {
 	RDMA_TRANSPORT_RDMAOE
 };
 
+enum {
+	IV_LINK_LAYER_UNSPECIFIED,
+	IB_LINK_LAYER_INFINIBAND,
+	IB_LINK_LAYER_ETHERNET,
+};
+
 enum ib_device_cap_flags {
 	IB_DEVICE_RESIZE_MAX_WR		= 1,
 	IB_DEVICE_BAD_PKEY_CNTR		= (1<<1),
-- 
1.6.5.5
