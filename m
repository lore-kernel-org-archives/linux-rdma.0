From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 8/8] Add timestamp support in rc_pingpong
Date: Wed, 24 Feb 2016 11:42:04 +0200
Message-ID: <1456306924-31298-9-git-send-email-yishaih@mellanox.com>
References: <1456306924-31298-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456306924-31298-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add timestamp support in rc_pingpong, it can serve as some example
of using ibv_create_cq_ex and ibv_poll_cq_ex verbs.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/rc_pingpong.c | 130 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 114 insertions(+), 16 deletions(-)

diff --git a/examples/rc_pingpong.c b/examples/rc_pingpong.c
index 90a8320..bffcfe5 100644
--- a/examples/rc_pingpong.c
+++ b/examples/rc_pingpong.c
@@ -49,6 +49,14 @@
 
 #include "pingpong.h"
 
+#ifndef max
+#define max(x, y) (((x) > (y)) ? (x) : (y))
+#endif
+
+#ifndef min
+#define min(x, y) (((x) < (y)) ? (x) : (y))
+#endif
+
 enum {
 	PINGPONG_RECV_WRID = 1,
 	PINGPONG_SEND_WRID = 2,
@@ -56,6 +64,7 @@ enum {
 
 static int page_size;
 static int use_odp;
+static int use_ts;
 
 struct pingpong_context {
 	struct ibv_context	*context;
@@ -70,6 +79,7 @@ struct pingpong_context {
 	int			 rx_depth;
 	int			 pending;
 	struct ibv_port_attr     portinfo;
+	uint64_t		 completion_timestamp_mask;
 };
 
 struct pingpong_dest {
@@ -357,7 +367,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 		goto clean_comp_channel;
 	}
 
-	if (use_odp) {
+	if (use_odp || use_ts) {
 		const uint32_t rc_caps_mask = IBV_ODP_SUPPORT_SEND |
 					      IBV_ODP_SUPPORT_RECV;
 		struct ibv_device_attr_ex attrx;
@@ -367,12 +377,22 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 			goto clean_comp_channel;
 		}
 
-		if (!(attrx.odp_caps.general_caps & IBV_ODP_SUPPORT) ||
-		    (attrx.odp_caps.per_transport_caps.rc_odp_caps & rc_caps_mask) != rc_caps_mask) {
-			fprintf(stderr, "The device isn't ODP capable or does not support RC send and receive with ODP\n");
-			goto clean_comp_channel;
+		if (use_odp) {
+			if (!(attrx.odp_caps.general_caps & IBV_ODP_SUPPORT) ||
+			    (attrx.odp_caps.per_transport_caps.rc_odp_caps & rc_caps_mask) != rc_caps_mask) {
+				fprintf(stderr, "The device isn't ODP capable or does not support RC send and receive with ODP\n");
+				goto clean_comp_channel;
+			}
+			access_flags |= IBV_ACCESS_ON_DEMAND;
+		}
+
+		if (use_ts) {
+			if (!attrx.completion_timestamp_mask) {
+				fprintf(stderr, "The device isn't completion timestamp capable\n");
+				goto clean_comp_channel;
+			}
+			ctx->completion_timestamp_mask = attrx.completion_timestamp_mask;
 		}
-		access_flags |= IBV_ACCESS_ON_DEMAND;
 	}
 	ctx->mr = ibv_reg_mr(ctx->pd, ctx->buf, size, access_flags);
 
@@ -381,8 +401,23 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 		goto clean_pd;
 	}
 
-	ctx->cq = ibv_create_cq(ctx->context, rx_depth + 1, NULL,
+	if (use_ts) {
+		struct ibv_cq_init_attr_ex attr_ex = {
+			.cqe = rx_depth + 1,
+			.cq_context = NULL,
+			.channel = ctx->channel,
+			.comp_vector = 0,
+			.comp_mask   = IBV_CQ_INIT_ATTR_FLAGS,
+			.flags = IBV_CREATE_CQ_ATTR_COMPLETION_TIMESTAMP,
+			.wc_flags = IBV_WC_EX_WITH_COMPLETION_TIMESTAMP
+		};
+
+		ctx->cq = ibv_create_cq_ex(ctx->context, &attr_ex);
+	} else {
+		ctx->cq = ibv_create_cq(ctx->context, rx_depth + 1, NULL,
 				ctx->channel, 0);
+	}
+
 	if (!ctx->cq) {
 		fprintf(stderr, "Couldn't create CQ\n");
 		goto clean_mr;
@@ -561,6 +596,7 @@ static void usage(const char *argv0)
 	printf("  -e, --events           sleep on CQ events (default poll)\n");
 	printf("  -g, --gid-idx=<gid index> local port gid index\n");
 	printf("  -o, --odp		    use on demand paging\n");
+	printf("  -t, --ts	            get CQE with timestamp\n");
 }
 
 int main(int argc, char *argv[])
@@ -586,6 +622,12 @@ int main(int argc, char *argv[])
 	int                      sl = 0;
 	int			 gidx = -1;
 	char			 gid[33];
+	unsigned int		 comp_recv_max_time_delta = 0;
+	unsigned int		 comp_recv_min_time_delta = 0xffffffff;
+	uint64_t		 comp_recv_total_time_delta = 0;
+	uint64_t		 comp_recv_prev_time = 0;
+	int			 last_comp_with_ts = 0;
+	unsigned int		 comp_with_time_iters = 0;
 
 	srand48(getpid() * time(NULL));
 
@@ -604,11 +646,12 @@ int main(int argc, char *argv[])
 			{ .name = "events",   .has_arg = 0, .val = 'e' },
 			{ .name = "gid-idx",  .has_arg = 1, .val = 'g' },
 			{ .name = "odp",      .has_arg = 0, .val = 'o' },
+			{ .name = "ts",       .has_arg = 0, .val = 't' },
 			{ 0 }
 		};
 
-		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:eg:o",
-							long_options, NULL);
+		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:eg:ot",
+				long_options, NULL);
 
 		if (c == -1)
 			break;
@@ -669,6 +712,9 @@ int main(int argc, char *argv[])
 		case 'o':
 			use_odp = 1;
 			break;
+		case 't':
+			use_ts = 1;
+			break;
 
 		default:
 			usage(argv[0]);
@@ -812,10 +858,24 @@ int main(int argc, char *argv[])
 
 		{
 			struct ibv_wc wc[2];
+			struct {
+				struct ibv_wc_ex wc_ex;
+				uint64_t	 completion_timestamp;
+			} wc_with_ts[2];
+			struct ibv_poll_cq_ex_attr attr = {
+				.comp_mask = 0,
+				.max_entries = 2
+			};
+			enum ibv_wc_status       status;
+			uint64_t                 wr_id;
 			int ne, i;
 
 			do {
-				ne = ibv_poll_cq(ctx->cq, 2, wc);
+				if (use_ts)
+					ne = ibv_poll_cq_ex(ctx->cq, &wc_with_ts[0].wc_ex, &attr);
+				else
+					ne = ibv_poll_cq(ctx->cq, 2, wc);
+
 				if (ne < 0) {
 					fprintf(stderr, "poll CQ failed %d\n", ne);
 					return 1;
@@ -824,14 +884,22 @@ int main(int argc, char *argv[])
 			} while (!use_event && ne < 1);
 
 			for (i = 0; i < ne; ++i) {
-				if (wc[i].status != IBV_WC_SUCCESS) {
+				if (use_ts) {
+					status = wc_with_ts[i].wc_ex.status;
+					wr_id = wc_with_ts[i].wc_ex.wr_id;
+				} else {
+					status = wc[i].status;
+					wr_id = wc[i].wr_id;
+				}
+
+				if (status != IBV_WC_SUCCESS) {
 					fprintf(stderr, "Failed status %s (%d) for wr_id %d\n",
-						ibv_wc_status_str(wc[i].status),
-						wc[i].status, (int) wc[i].wr_id);
+						ibv_wc_status_str(status),
+						status, (int)wr_id);
 					return 1;
 				}
 
-				switch ((int) wc[i].wr_id) {
+				switch ((int)wr_id) {
 				case PINGPONG_SEND_WRID:
 					++scnt;
 					break;
@@ -848,15 +916,39 @@ int main(int argc, char *argv[])
 					}
 
 					++rcnt;
+					if (use_ts && (wc_with_ts[i].wc_ex.wc_flags &
+						       IBV_WC_EX_WITH_COMPLETION_TIMESTAMP)) {
+						if (last_comp_with_ts) {
+							uint64_t delta;
+
+							/* checking whether the clock was wrapped around */
+							if (wc_with_ts[i].completion_timestamp >= comp_recv_prev_time)
+								delta = wc_with_ts[i].completion_timestamp - comp_recv_prev_time;
+							else
+								delta = ctx->completion_timestamp_mask - comp_recv_prev_time +
+										wc_with_ts[i].completion_timestamp + 1;
+
+							comp_recv_max_time_delta = max(comp_recv_max_time_delta, delta);
+							comp_recv_min_time_delta = min(comp_recv_min_time_delta, delta);
+							comp_recv_total_time_delta += delta;
+							comp_with_time_iters++;
+						}
+
+						comp_recv_prev_time = wc_with_ts[i].completion_timestamp;
+						last_comp_with_ts = 1;
+					} else {
+						last_comp_with_ts = 0;
+					}
+
 					break;
 
 				default:
 					fprintf(stderr, "Completion for unknown wr_id %d\n",
-						(int) wc[i].wr_id);
+						(int)wr_id);
 					return 1;
 				}
 
-				ctx->pending &= ~(int) wc[i].wr_id;
+				ctx->pending &= ~(int)wr_id;
 				if (scnt < iters && !ctx->pending) {
 					if (pp_post_send(ctx)) {
 						fprintf(stderr, "Couldn't post send\n");
@@ -883,6 +975,12 @@ int main(int argc, char *argv[])
 		       bytes, usec / 1000000., bytes * 8. / usec);
 		printf("%d iters in %.2f seconds = %.2f usec/iter\n",
 		       iters, usec / 1000000., usec / iters);
+
+		if (use_ts && comp_with_time_iters) {
+			printf("Max receive completion clock cycles = %u\n", comp_recv_max_time_delta);
+			printf("Min receive completion clock cycles = %u\n", comp_recv_min_time_delta);
+			printf("Average receive completion clock cycles = %f\n", (double)comp_recv_total_time_delta / comp_with_time_iters);
+		}
 	}
 
 	ibv_ack_cq_events(ctx->cq, num_cq_events);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
