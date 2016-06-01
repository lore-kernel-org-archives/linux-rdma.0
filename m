From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V5 libibverbs 7/7] Add timestamp support in rc_pingpong
Date: Wed,  1 Jun 2016 16:05:40 +0300
Message-ID: <1464786340-7630-8-git-send-email-yishaih@mellanox.com>
References: <1464786340-7630-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464786340-7630-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add timestamp support in rc_pingpong, it can serve as some example
of using ibv_create_cq_ex verb and the new
ibv_wc_read_xxx accessors.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/rc_pingpong.c | 278 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 215 insertions(+), 63 deletions(-)

diff --git a/examples/rc_pingpong.c b/examples/rc_pingpong.c
index 90a8320..8d58357 100644
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
@@ -56,13 +64,17 @@ enum {
 
 static int page_size;
 static int use_odp;
+static int use_ts;
 
 struct pingpong_context {
 	struct ibv_context	*context;
 	struct ibv_comp_channel *channel;
 	struct ibv_pd		*pd;
 	struct ibv_mr		*mr;
-	struct ibv_cq		*cq;
+	union {
+		struct ibv_cq		*cq;
+		struct ibv_cq_ex	*cq_ex;
+	} cq_s;
 	struct ibv_qp		*qp;
 	void			*buf;
 	int			 size;
@@ -70,8 +82,15 @@ struct pingpong_context {
 	int			 rx_depth;
 	int			 pending;
 	struct ibv_port_attr     portinfo;
+	uint64_t		 completion_timestamp_mask;
 };
 
+struct ibv_cq *pp_cq(struct pingpong_context *ctx)
+{
+	return use_ts ? ibv_cq_ex_to_cq(ctx->cq_s.cq_ex) :
+		ctx->cq_s.cq;
+}
+
 struct pingpong_dest {
 	int lid;
 	int qpn;
@@ -357,7 +376,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 		goto clean_comp_channel;
 	}
 
-	if (use_odp) {
+	if (use_odp || use_ts) {
 		const uint32_t rc_caps_mask = IBV_ODP_SUPPORT_SEND |
 					      IBV_ODP_SUPPORT_RECV;
 		struct ibv_device_attr_ex attrx;
@@ -367,12 +386,22 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
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
 
@@ -381,9 +410,22 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 		goto clean_pd;
 	}
 
-	ctx->cq = ibv_create_cq(ctx->context, rx_depth + 1, NULL,
-				ctx->channel, 0);
-	if (!ctx->cq) {
+	if (use_ts) {
+		struct ibv_cq_init_attr_ex attr_ex = {
+			.cqe = rx_depth + 1,
+			.cq_context = NULL,
+			.channel = ctx->channel,
+			.comp_vector = 0,
+			.wc_flags = IBV_WC_EX_WITH_COMPLETION_TIMESTAMP
+		};
+
+		ctx->cq_s.cq_ex = ibv_create_cq_ex(ctx->context, &attr_ex);
+	} else {
+		ctx->cq_s.cq = ibv_create_cq(ctx->context, rx_depth + 1, NULL,
+					     ctx->channel, 0);
+	}
+
+	if (!pp_cq(ctx)) {
 		fprintf(stderr, "Couldn't create CQ\n");
 		goto clean_mr;
 	}
@@ -391,8 +433,8 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 	{
 		struct ibv_qp_attr attr;
 		struct ibv_qp_init_attr init_attr = {
-			.send_cq = ctx->cq,
-			.recv_cq = ctx->cq,
+			.send_cq = pp_cq(ctx),
+			.recv_cq = pp_cq(ctx),
 			.cap     = {
 				.max_send_wr  = 1,
 				.max_recv_wr  = rx_depth,
@@ -438,7 +480,7 @@ clean_qp:
 	ibv_destroy_qp(ctx->qp);
 
 clean_cq:
-	ibv_destroy_cq(ctx->cq);
+	ibv_destroy_cq(pp_cq(ctx));
 
 clean_mr:
 	ibv_dereg_mr(ctx->mr);
@@ -469,7 +511,7 @@ int pp_close_ctx(struct pingpong_context *ctx)
 		return 1;
 	}
 
-	if (ibv_destroy_cq(ctx->cq)) {
+	if (ibv_destroy_cq(pp_cq(ctx))) {
 		fprintf(stderr, "Couldn't destroy CQ\n");
 		return 1;
 	}
@@ -543,6 +585,89 @@ static int pp_post_send(struct pingpong_context *ctx)
 	return ibv_post_send(ctx->qp, &wr, &bad_wr);
 }
 
+struct ts_params {
+	unsigned int		 comp_recv_max_time_delta;
+	unsigned int		 comp_recv_min_time_delta;
+	uint64_t		 comp_recv_total_time_delta;
+	uint64_t		 comp_recv_prev_time;
+	int			 last_comp_with_ts;
+	unsigned int		 comp_with_time_iters;
+};
+
+static inline int parse_single_wc(struct pingpong_context *ctx, int *scnt,
+				  int *rcnt, int *routs, int iters,
+				  uint64_t wr_id, enum ibv_wc_status status,
+				  uint64_t completion_timestamp,
+				  struct ts_params *ts)
+{
+	if (status != IBV_WC_SUCCESS) {
+		fprintf(stderr, "Failed status %s (%d) for wr_id %d\n",
+			ibv_wc_status_str(status),
+			status, (int)wr_id);
+		return 1;
+	}
+
+	switch ((int)wr_id) {
+	case PINGPONG_SEND_WRID:
+		++(*scnt);
+		break;
+
+	case PINGPONG_RECV_WRID:
+		if (--(*routs) <= 1) {
+			*routs += pp_post_recv(ctx, ctx->rx_depth - *routs);
+			if (*routs < ctx->rx_depth) {
+				fprintf(stderr,
+					"Couldn't post receive (%d)\n",
+					*routs);
+				return 1;
+			}
+		}
+
+		++(*rcnt);
+		if (use_ts) {
+			if (ts->last_comp_with_ts) {
+				uint64_t delta;
+
+				/* checking whether the clock was wrapped around */
+				if (completion_timestamp >= ts->comp_recv_prev_time)
+					delta = completion_timestamp - ts->comp_recv_prev_time;
+				else
+					delta = ctx->completion_timestamp_mask - ts->comp_recv_prev_time +
+						completion_timestamp + 1;
+
+				ts->comp_recv_max_time_delta = max(ts->comp_recv_max_time_delta, delta);
+				ts->comp_recv_min_time_delta = min(ts->comp_recv_min_time_delta, delta);
+				ts->comp_recv_total_time_delta += delta;
+				ts->comp_with_time_iters++;
+			}
+
+			ts->comp_recv_prev_time = completion_timestamp;
+			ts->last_comp_with_ts = 1;
+		} else {
+			ts->last_comp_with_ts = 0;
+		}
+
+		break;
+
+	default:
+		fprintf(stderr, "Completion for unknown wr_id %d\n",
+			(int)wr_id);
+		return 1;
+	}
+
+	ctx->pending &= ~(int)wr_id;
+	if (*scnt < iters && !ctx->pending) {
+		if (pp_post_send(ctx)) {
+			fprintf(stderr, "Couldn't post send\n");
+			return 1;
+		}
+		ctx->pending = PINGPONG_RECV_WRID |
+			PINGPONG_SEND_WRID;
+	}
+
+	return 0;
+}
+
 static void usage(const char *argv0)
 {
 	printf("Usage:\n");
@@ -561,6 +686,7 @@ static void usage(const char *argv0)
 	printf("  -e, --events           sleep on CQ events (default poll)\n");
 	printf("  -g, --gid-idx=<gid index> local port gid index\n");
 	printf("  -o, --odp		    use on demand paging\n");
+	printf("  -t, --ts	            get CQE with timestamp\n");
 }
 
 int main(int argc, char *argv[])
@@ -586,6 +712,7 @@ int main(int argc, char *argv[])
 	int                      sl = 0;
 	int			 gidx = -1;
 	char			 gid[33];
+	struct ts_params	 ts;
 
 	srand48(getpid() * time(NULL));
 
@@ -604,11 +731,12 @@ int main(int argc, char *argv[])
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
@@ -669,6 +797,9 @@ int main(int argc, char *argv[])
 		case 'o':
 			use_odp = 1;
 			break;
+		case 't':
+			use_ts = 1;
+			break;
 
 		default:
 			usage(argv[0]);
@@ -683,6 +814,15 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
+	if (use_ts) {
+		ts.comp_recv_max_time_delta = 0;
+		ts.comp_recv_min_time_delta = 0xffffffff;
+		ts.comp_recv_total_time_delta = 0;
+		ts.comp_recv_prev_time = 0;
+		ts.last_comp_with_ts = 0;
+		ts.comp_with_time_iters = 0;
+	}
+
 	page_size = sysconf(_SC_PAGESIZE);
 
 	dev_list = ibv_get_device_list(NULL);
@@ -720,7 +860,7 @@ int main(int argc, char *argv[])
 	}
 
 	if (use_event)
-		if (ibv_req_notify_cq(ctx->cq, 0)) {
+		if (ibv_req_notify_cq(pp_cq(ctx), 0)) {
 			fprintf(stderr, "Couldn't request CQ notification\n");
 			return 1;
 		}
@@ -788,6 +928,8 @@ int main(int argc, char *argv[])
 
 	rcnt = scnt = 0;
 	while (rcnt < iters || scnt < iters) {
+		int ret;
+
 		if (use_event) {
 			struct ibv_cq *ev_cq;
 			void          *ev_ctx;
@@ -799,72 +941,73 @@ int main(int argc, char *argv[])
 
 			++num_cq_events;
 
-			if (ev_cq != ctx->cq) {
+			if (ev_cq != pp_cq(ctx)) {
 				fprintf(stderr, "CQ event for unknown CQ %p\n", ev_cq);
 				return 1;
 			}
 
-			if (ibv_req_notify_cq(ctx->cq, 0)) {
+			if (ibv_req_notify_cq(pp_cq(ctx), 0)) {
 				fprintf(stderr, "Couldn't request CQ notification\n");
 				return 1;
 			}
 		}
 
-		{
-			struct ibv_wc wc[2];
+		if (use_ts) {
+			struct ibv_poll_cq_attr attr = {};
+
+			do {
+				ret = ibv_start_poll(ctx->cq_s.cq_ex, &attr);
+			} while (!use_event && ret == ENOENT);
+
+			if (ret) {
+				fprintf(stderr, "poll CQ failed %d\n", ret);
+				return ret;
+			}
+			ret = parse_single_wc(ctx, &scnt, &rcnt, &routs,
+					      iters,
+					      ctx->cq_s.cq_ex->wr_id,
+					      ctx->cq_s.cq_ex->status,
+					      ibv_wc_read_completion_ts(ctx->cq_s.cq_ex),
+					      &ts);
+			if (ret) {
+				ibv_end_poll(ctx->cq_s.cq_ex);
+				return ret;
+			}
+			ret = ibv_next_poll(ctx->cq_s.cq_ex);
+			if (!ret)
+				ret = parse_single_wc(ctx, &scnt, &rcnt, &routs,
+						      iters,
+						      ctx->cq_s.cq_ex->wr_id,
+						      ctx->cq_s.cq_ex->status,
+						      ibv_wc_read_completion_ts(ctx->cq_s.cq_ex),
+						      &ts);
+			ibv_end_poll(ctx->cq_s.cq_ex);
+			if (ret && ret != ENOENT) {
+				fprintf(stderr, "poll CQ failed %d\n", ret);
+				return ret;
+			}
+		} else {
 			int ne, i;
+			struct ibv_wc wc[2];
 
 			do {
-				ne = ibv_poll_cq(ctx->cq, 2, wc);
+				ne = ibv_poll_cq(pp_cq(ctx), 2, wc);
 				if (ne < 0) {
 					fprintf(stderr, "poll CQ failed %d\n", ne);
 					return 1;
 				}
-
 			} while (!use_event && ne < 1);
 
 			for (i = 0; i < ne; ++i) {
-				if (wc[i].status != IBV_WC_SUCCESS) {
-					fprintf(stderr, "Failed status %s (%d) for wr_id %d\n",
-						ibv_wc_status_str(wc[i].status),
-						wc[i].status, (int) wc[i].wr_id);
+				ret = parse_single_wc(ctx, &scnt, &rcnt, &routs,
+						      iters,
+						      wc[i].wr_id,
+						      wc[i].status,
+						      0, &ts);
+				if (ret) {
+					fprintf(stderr, "parse WC failed %d\n", ne);
 					return 1;
 				}
-
-				switch ((int) wc[i].wr_id) {
-				case PINGPONG_SEND_WRID:
-					++scnt;
-					break;
-
-				case PINGPONG_RECV_WRID:
-					if (--routs <= 1) {
-						routs += pp_post_recv(ctx, ctx->rx_depth - routs);
-						if (routs < ctx->rx_depth) {
-							fprintf(stderr,
-								"Couldn't post receive (%d)\n",
-								routs);
-							return 1;
-						}
-					}
-
-					++rcnt;
-					break;
-
-				default:
-					fprintf(stderr, "Completion for unknown wr_id %d\n",
-						(int) wc[i].wr_id);
-					return 1;
-				}
-
-				ctx->pending &= ~(int) wc[i].wr_id;
-				if (scnt < iters && !ctx->pending) {
-					if (pp_post_send(ctx)) {
-						fprintf(stderr, "Couldn't post send\n");
-						return 1;
-					}
-					ctx->pending = PINGPONG_RECV_WRID |
-						       PINGPONG_SEND_WRID;
-				}
 			}
 		}
 	}
@@ -883,9 +1026,18 @@ int main(int argc, char *argv[])
 		       bytes, usec / 1000000., bytes * 8. / usec);
 		printf("%d iters in %.2f seconds = %.2f usec/iter\n",
 		       iters, usec / 1000000., usec / iters);
+
+		if (use_ts && ts.comp_with_time_iters) {
+			printf("Max receive completion clock cycles = %u\n",
+			       ts.comp_recv_max_time_delta);
+			printf("Min receive completion clock cycles = %u\n",
+			       ts.comp_recv_min_time_delta);
+			printf("Average receive completion clock cycles = %f\n",
+			       (double)ts.comp_recv_total_time_delta / ts.comp_with_time_iters);
+		}
 	}
 
-	ibv_ack_cq_events(ctx->cq, num_cq_events);
+	ibv_ack_cq_events(pp_cq(ctx), num_cq_events);
 
 	if (pp_close_ctx(ctx))
 		return 1;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
