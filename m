From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 02/23] perftest_resources: print error received for debug convenience
Date: Thu, 18 Aug 2016 13:31:57 -0400
Message-ID: <1471541538-20270-3-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/perftest_resources.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/src/perftest_resources.c b/src/perftest_resources.c
index f23dabb..4dc0705 100755
--- a/src/perftest_resources.c
+++ b/src/perftest_resources.c
@@ -1855,7 +1855,7 @@ int ctx_modify_dc_qp_to_init(struct ibv_qp *qp,struct perftest_parameters *user_
 	#endif
 
 	if (err) {
-		fprintf(stderr, "Failed to modify QP to INIT\n");
+		fprintf(stderr, "Failed to modify QP to INIT (%s)\n", strerror(err));
 		return 1;
 	}
 	return 0;
@@ -1951,7 +1951,7 @@ int ctx_modify_qp_to_init(struct ibv_qp *qp,struct perftest_parameters *user_par
 		ret = ibv_modify_qp(qp,&attr,flags);
 
 	if (ret) {
-		fprintf(stderr, "Failed to modify QP to INIT, ret=%d\n",ret);
+		fprintf(stderr, "Failed to modify QP to INIT, (%s)\n",strerror(ret));
 		return 1;
 	}
 	return 0;
@@ -2261,7 +2261,7 @@ int ctx_connect(struct pingpong_context *ctx,
 
 			err = ibv_query_qp(ctx->qp[i], &qp_attr, IBV_QP_AV, &init_attr);
 			if (err)
-				fprintf(stderr, "ibv_query_qp failed to get ah_attr\n");
+				fprintf(stderr, "ibv_query_qp failed to get ah_attr (%s)\n", strerror(err));
 			else
 				qp_static_rate = (int)(qp_attr.ah_attr.static_rate);
 
@@ -2816,7 +2816,7 @@ int perform_warm_up(struct pingpong_context *ctx,struct perftest_parameters *use
 			#endif
 
 			if (err) {
-				fprintf(stderr,"Couldn't post send during warm up: qp %d scnt=%d \n",index,warmindex);
+				fprintf(stderr,"Couldn't post send during warm up: qp %d scnt=%d, err=%s\n",index,warmindex,strerror(err));
 				return_value = 1;
 				goto cleaning;
 			}
@@ -4016,7 +4016,7 @@ int run_iter_lat_write(struct pingpong_context *ctx,struct perftest_parameters *
 			err = ibv_post_send(ctx->qp[0],&ctx->wr[0],&bad_wr);
 			#endif
 			if (err) {
-				fprintf(stderr,"Couldn't post send: scnt=%lu\n",scnt);
+				fprintf(stderr,"%s: Couldn't post send: scnt=%lu, err=%s\n",__func__,scnt,strerror(err));
 				return 1;
 			}
 		}
@@ -4110,7 +4110,7 @@ int run_iter_lat(struct pingpong_context *ctx,struct perftest_parameters *user_p
 		err = ibv_post_send(ctx->qp[0],&ctx->wr[0],&bad_wr);
 		#endif
 		if (err) {
-			fprintf(stderr,"Couldn't post send: scnt=%lu\n",scnt);
+			fprintf(stderr,"%s: Couldn't post send: scnt=%lu, err=%s\n",__func__,scnt,strerror(err));
 			return 1;
 		}
 
@@ -4310,7 +4310,7 @@ int run_iter_lat_send(struct pingpong_context *ctx,struct perftest_parameters *u
 			err = ibv_post_send(ctx->qp[0],&ctx->wr[0],&bad_wr);
 			#endif
 			if (err) {
-				fprintf(stderr,"Couldn't post send: scnt=%lu \n",scnt);
+				fprintf(stderr,"%s: Couldn't post send: scnt=%lu, err=%s \n",__func__,scnt,strerror(err));
 				return 1;
 			}
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
