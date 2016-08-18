From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 20/23] raw_ethernet_send_lat: prevent possible destroy on uninit val
Date: Thu, 18 Aug 2016 13:32:15 -0400
Message-ID: <1471541538-20270-21-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Because user_param gets twiddled so much, coverity/clang think it could be
possible for the value of user_param.flows to change over time, which
could result in trying to call ibv_destroy_flow() on an uninitialized
flow_create_result[i]. Just save user_param.flows to a local variable and
use it for loop iterations to ensure consistency.

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/raw_ethernet_send_lat.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/src/raw_ethernet_send_lat.c b/src/raw_ethernet_send_lat.c
index 6d0bbf9..b6bce26 100755
--- a/src/raw_ethernet_send_lat.c
+++ b/src/raw_ethernet_send_lat.c
@@ -75,7 +75,7 @@ int main(int argc, char *argv[])
 	struct ibv_flow_attr		**flow_rules;
 	#endif
 	struct report_options		report;
-	int				i;
+	int				i, flows;
 
 	/* allocate memory space for user parameters &*/
 	memset(&ctx,		0, sizeof(struct pingpong_context));
@@ -104,12 +104,13 @@ int main(int argc, char *argv[])
 		DEBUG_LOG(TRACE,"<<<<<<%s",__FUNCTION__);
 		return FAILURE;
 	}
+	flows = user_param.flows;
 	#ifdef HAVE_RAW_ETH_EXP
-	ALLOCATE(flow_create_result, struct ibv_exp_flow*, user_param.flows);
-	ALLOCATE(flow_rules, struct ibv_exp_flow_attr*, user_param.flows);
+	ALLOCATE(flow_create_result, struct ibv_exp_flow*, flows);
+	ALLOCATE(flow_rules, struct ibv_exp_flow_attr*, flows);
 	#else
-	ALLOCATE(flow_create_result, struct ibv_flow*, user_param.flows);
-	ALLOCATE(flow_rules, struct ibv_flow_attr*, user_param.flows);
+	ALLOCATE(flow_create_result, struct ibv_flow*, flows);
+	ALLOCATE(flow_rules, struct ibv_flow_attr*, flows);
 	#endif
 
 
@@ -160,7 +161,7 @@ int main(int argc, char *argv[])
 	/* Print basic test information. */
 	ctx_print_test_info(&user_param);
 
-	for (i = 0; i < user_param.flows; i++)
+	for (i = 0; i < flows; i++)
 		print_spec(flow_rules[i], &user_param);
 
 	/* Create (if necessary) the rdma_cm ids and channel. */
@@ -196,7 +197,7 @@ int main(int argc, char *argv[])
 
 
 	/* attaching the qp to the spec */
-	for (i = 0; i < user_param.flows; i++) {
+	for (i = 0; i < flows; i++) {
 		#ifdef HAVE_RAW_ETH_EXP
 		flow_create_result[i] = ibv_exp_create_flow(ctx.qp[0], flow_rules[i]);
 		#else
@@ -274,7 +275,7 @@ int main(int argc, char *argv[])
 	#endif
 
 	/* destroy flow */
-	for (i = 0; i < user_param.flows; i++) {
+	for (i = 0; i < flows; i++) {
 		#ifdef HAVE_RAW_ETH_EXP
 		if (ibv_exp_destroy_flow(flow_create_result[i])) {
 		#else
@@ -292,14 +293,15 @@ int main(int argc, char *argv[])
 	if (destroy_ctx(&ctx, &user_param)) {
 		fprintf(stderr,"Failed to destroy_ctx\n");
 		DEBUG_LOG(TRACE,"<<<<<<%s",__FUNCTION__);
-		return FAILURE;
+		goto free_flows;
 	}
 
 	if (user_param.output == FULL_VERBOSITY)
 		printf(RESULT_LINE);
 
 	DEBUG_LOG(TRACE,"<<<<<<%s",__FUNCTION__);
-	return 0;
+	ret_val = SUCCESS;
+	goto free_flows;
 
 eexists:
 	ret_val = 17;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
