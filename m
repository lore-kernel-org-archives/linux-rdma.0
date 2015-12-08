From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC libibverbs 2/2] Example code to use contig pages
Date: Tue,  8 Dec 2015 17:17:05 +0200
Message-ID: <1449587825-26444-3-git-send-email-yishaih@mellanox.com>
References: <1449587825-26444-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449587825-26444-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Example usage of contig pages.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/rc_pingpong.c | 47 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/examples/rc_pingpong.c b/examples/rc_pingpong.c
index 90a8320..ca8e16f 100644
--- a/examples/rc_pingpong.c
+++ b/examples/rc_pingpong.c
@@ -56,6 +56,7 @@ enum {
 
 static int page_size;
 static int use_odp;
+static int use_contiguous_mr;
 
 struct pingpong_context {
 	struct ibv_context	*context;
@@ -326,15 +327,14 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 	ctx->send_flags = IBV_SEND_SIGNALED;
 	ctx->rx_depth   = rx_depth;
 
-	ctx->buf = memalign(page_size, size);
-	if (!ctx->buf) {
-		fprintf(stderr, "Couldn't allocate work buf.\n");
-		goto clean_ctx;
+	if (!use_contiguous_mr) {
+		ctx->buf = memalign(page_size, size);
+		if (!ctx->buf) {
+			fprintf(stderr, "Couldn't allocate work buf.\n");
+			goto clean_ctx;
+		}
 	}
 
-	/* FIXME memset(ctx->buf, 0, size); */
-	memset(ctx->buf, 0x7b, size);
-
 	ctx->context = ibv_open_device(ib_dev);
 	if (!ctx->context) {
 		fprintf(stderr, "Couldn't get context for %s\n",
@@ -374,13 +374,24 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 		}
 		access_flags |= IBV_ACCESS_ON_DEMAND;
 	}
-	ctx->mr = ibv_reg_mr(ctx->pd, ctx->buf, size, access_flags);
+
+	if (use_contiguous_mr)
+		ctx->mr = ibv_reg_mr(ctx->pd, NULL, size,
+				IBV_ACCESS_LOCAL_WRITE | IBV_ACCESS_ALLOC_MR);
+	else
+		ctx->mr = ibv_reg_mr(ctx->pd, ctx->buf, size, access_flags);
 
 	if (!ctx->mr) {
 		fprintf(stderr, "Couldn't register MR\n");
 		goto clean_pd;
 	}
 
+	if (use_contiguous_mr)
+		ctx->buf = ctx->mr->addr;
+
+	/* FIXME memset(ctx->buf, 0, size); */
+	memset(ctx->buf, 0x7b, size);
+
 	ctx->cq = ibv_create_cq(ctx->context, rx_depth + 1, NULL,
 				ctx->channel, 0);
 	if (!ctx->cq) {
@@ -454,7 +465,8 @@ clean_device:
 	ibv_close_device(ctx->context);
 
 clean_buffer:
-	free(ctx->buf);
+	if (!use_contiguous_mr)
+		free(ctx->buf);
 
 clean_ctx:
 	free(ctx);
@@ -496,7 +508,9 @@ int pp_close_ctx(struct pingpong_context *ctx)
 		return 1;
 	}
 
-	free(ctx->buf);
+	if (!use_contiguous_mr)
+		free(ctx->buf);
+
 	free(ctx);
 
 	return 0;
@@ -561,6 +575,7 @@ static void usage(const char *argv0)
 	printf("  -e, --events           sleep on CQ events (default poll)\n");
 	printf("  -g, --gid-idx=<gid index> local port gid index\n");
 	printf("  -o, --odp		    use on demand paging\n");
+	printf("  -c, --contiguous-mr    use contiguous mr\n");
 }
 
 int main(int argc, char *argv[])
@@ -604,10 +619,11 @@ int main(int argc, char *argv[])
 			{ .name = "events",   .has_arg = 0, .val = 'e' },
 			{ .name = "gid-idx",  .has_arg = 1, .val = 'g' },
 			{ .name = "odp",      .has_arg = 0, .val = 'o' },
+			{ .name = "contiguous-mr", .has_arg = 0, .val = 'c' },
 			{ 0 }
 		};
 
-		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:eg:o",
+		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:eg:oc",
 							long_options, NULL);
 
 		if (c == -1)
@@ -670,6 +686,10 @@ int main(int argc, char *argv[])
 			use_odp = 1;
 			break;
 
+		case 'c':
+			++use_contiguous_mr;
+			break;
+
 		default:
 			usage(argv[0]);
 			return 1;
@@ -683,6 +703,11 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
+	if (use_contiguous_mr && use_odp) {
+		fprintf(stderr, "contiguous mr should not be used with ODP\n");
+		return 1;
+	}
+
 	page_size = sysconf(_SC_PAGESIZE);
 
 	dev_list = ibv_get_device_list(NULL);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
