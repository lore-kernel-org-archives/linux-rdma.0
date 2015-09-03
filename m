From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 3/3] libibverbs/examples: Support odp in rc_pingpong
Date: Thu,  3 Sep 2015 17:56:39 +0300
Message-ID: <1441292199-8371-4-git-send-email-haggaie@mellanox.com>
References: <1441292199-8371-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441292199-8371-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/rc_pingpong.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/examples/rc_pingpong.c b/examples/rc_pingpong.c
index ddfe8d007e1a..90a8320121b9 100644
--- a/examples/rc_pingpong.c
+++ b/examples/rc_pingpong.c
@@ -55,6 +55,7 @@ enum {
 };
 
 static int page_size;
+static int use_odp;
 
 struct pingpong_context {
 	struct ibv_context	*context;
@@ -315,6 +316,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 					    int use_event)
 {
 	struct pingpong_context *ctx;
+	int access_flags = IBV_ACCESS_LOCAL_WRITE;
 
 	ctx = calloc(1, sizeof *ctx);
 	if (!ctx)
@@ -355,7 +357,25 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 		goto clean_comp_channel;
 	}
 
-	ctx->mr = ibv_reg_mr(ctx->pd, ctx->buf, size, IBV_ACCESS_LOCAL_WRITE);
+	if (use_odp) {
+		const uint32_t rc_caps_mask = IBV_ODP_SUPPORT_SEND |
+					      IBV_ODP_SUPPORT_RECV;
+		struct ibv_device_attr_ex attrx;
+
+		if (ibv_query_device_ex(ctx->context, NULL, &attrx)) {
+			fprintf(stderr, "Couldn't query device for its features\n");
+			goto clean_comp_channel;
+		}
+
+		if (!(attrx.odp_caps.general_caps & IBV_ODP_SUPPORT) ||
+		    (attrx.odp_caps.per_transport_caps.rc_odp_caps & rc_caps_mask) != rc_caps_mask) {
+			fprintf(stderr, "The device isn't ODP capable or does not support RC send and receive with ODP\n");
+			goto clean_comp_channel;
+		}
+		access_flags |= IBV_ACCESS_ON_DEMAND;
+	}
+	ctx->mr = ibv_reg_mr(ctx->pd, ctx->buf, size, access_flags);
+
 	if (!ctx->mr) {
 		fprintf(stderr, "Couldn't register MR\n");
 		goto clean_pd;
@@ -540,6 +560,7 @@ static void usage(const char *argv0)
 	printf("  -l, --sl=<sl>          service level value\n");
 	printf("  -e, --events           sleep on CQ events (default poll)\n");
 	printf("  -g, --gid-idx=<gid index> local port gid index\n");
+	printf("  -o, --odp		    use on demand paging\n");
 }
 
 int main(int argc, char *argv[])
@@ -582,11 +603,13 @@ int main(int argc, char *argv[])
 			{ .name = "sl",       .has_arg = 1, .val = 'l' },
 			{ .name = "events",   .has_arg = 0, .val = 'e' },
 			{ .name = "gid-idx",  .has_arg = 1, .val = 'g' },
+			{ .name = "odp",      .has_arg = 0, .val = 'o' },
 			{ 0 }
 		};
 
-		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:eg:",
+		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:l:eg:o",
 							long_options, NULL);
+
 		if (c == -1)
 			break;
 
@@ -643,6 +666,10 @@ int main(int argc, char *argv[])
 			gidx = strtol(optarg, NULL, 0);
 			break;
 
+		case 'o':
+			use_odp = 1;
+			break;
+
 		default:
 			usage(argv[0]);
 			return 1;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
