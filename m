From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 06/23] raw_ethernet_send_lat: fix assorted memory leaks on error paths
Date: Thu, 18 Aug 2016 13:32:01 -0400
Message-ID: <1471541538-20270-7-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fixing issues reported by clang.

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/raw_ethernet_send_lat.c | 43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/src/raw_ethernet_send_lat.c b/src/raw_ethernet_send_lat.c
index 4663714..6d0bbf9 100755
--- a/src/raw_ethernet_send_lat.c
+++ b/src/raw_ethernet_send_lat.c
@@ -64,6 +64,7 @@ int main(int argc, char *argv[])
 	struct pingpong_context		ctx;
 	struct raw_ethernet_info	my_dest_info,rem_dest_info;
 	int				ret_parser;
+	int				ret_val = FAILURE;
 	struct perftest_parameters	user_param;
 	#ifdef HAVE_RAW_ETH_EXP
 	struct ibv_exp_flow		**flow_create_result;
@@ -101,7 +102,7 @@ int main(int argc, char *argv[])
 		if (ret_parser != VERSION_EXIT && ret_parser != HELP_EXIT)
 			fprintf(stderr," Parser function exited with Error\n");
 		DEBUG_LOG(TRACE,"<<<<<<%s",__FUNCTION__);
-		return 1;
+		return FAILURE;
 	}
 	#ifdef HAVE_RAW_ETH_EXP
 	ALLOCATE(flow_create_result, struct ibv_exp_flow*, user_param.flows);
@@ -122,12 +123,12 @@ int main(int argc, char *argv[])
 	if (!ib_dev) {
 		fprintf(stderr," Unable to find the Infiniband/RoCE device\n");
 		DEBUG_LOG(TRACE,"<<<<<<%s",__FUNCTION__);
-		return 1;
+		goto free_flows;
 	}
 	GET_STRING(user_param.ib_devname, ibv_get_device_name(ib_dev));
 
 	if (check_flow_steering_support(user_param.ib_devname)) {
-		return 1;
+		goto free_flows;
 	}
 
 	/* Getting the relevant context from the device */
@@ -135,14 +136,14 @@ int main(int argc, char *argv[])
 	if (!ctx.context) {
 		fprintf(stderr, " Couldn't get context for the device\n");
 		DEBUG_LOG(TRACE,"<<<<<<%s",__FUNCTION__);
-		return 1;
+		goto free_flows;
 	}
 
 	/* See if MTU and link type are valid and supported. */
 	if (check_link_and_mtu(ctx.context, &user_param)) {
 		fprintf(stderr, " Couldn't get context for the device\n");
 		DEBUG_LOG(TRACE,"<<<<<<%s",__FUNCTION__);
-		return FAILURE;
+		goto free_flows;
 	}
 
 	/* Allocating arrays needed for the test. */
@@ -153,7 +154,7 @@ int main(int argc, char *argv[])
 	 */
 	if (send_set_up_connection(flow_rules, &ctx, &user_param, &my_dest_info, &rem_dest_info)) {
 		fprintf(stderr," Unable to set up socket connection\n");
-		return 1;
+		goto free_flows;
 	}
 
 	/* Print basic test information. */
@@ -167,7 +168,7 @@ int main(int argc, char *argv[])
 
 		if (create_rdma_resources(&ctx, &user_param)) {
 			fprintf(stderr," Unable to create the rdma_resources\n");
-			return FAILURE;
+			goto free_flows;
 		}
 
 		if (user_param.machine == CLIENT) {
@@ -175,13 +176,13 @@ int main(int argc, char *argv[])
 			/* Connects the client to a QP on the other machine with rdma_cm */
 			if (rdma_client_connect(&ctx, &user_param)) {
 				fprintf(stderr,"Unable to perform rdma_client function\n");
-				return FAILURE;
+				goto free_flows;
 			}
 
 		} else if (rdma_server_connect(&ctx, &user_param)) {
 			/* Assigning a server to listen on rdma_cm port and connect to it. */
 			fprintf(stderr,"Unable to perform rdma_server function\n");
-			return FAILURE;
+			goto free_flows;
 		}
 
 	} else {
@@ -189,7 +190,7 @@ int main(int argc, char *argv[])
 		/* initalize IB resources (data buffer, PD, MR, CQ and events channel) */
 		if (ctx_init(&ctx, &user_param)) {
 			fprintf(stderr, " Couldn't create IB resources\n");
-			return FAILURE;
+			goto free_flows;
 		}
 	}
 
@@ -205,7 +206,7 @@ int main(int argc, char *argv[])
 		if (!flow_create_result[i]){
 			perror("error");
 			fprintf(stderr, "Couldn't attach QP\n");
-			return FAILURE;
+			goto destroy_ctx;
 		}
 	}
 
@@ -239,7 +240,7 @@ int main(int argc, char *argv[])
 		if (ctx_connect(&ctx, NULL, &user_param, NULL)) {
 			fprintf(stderr," Unable to Connect the HCA's through the link\n");
 			DEBUG_LOG(TRACE,"<<<<<<%s",__FUNCTION__);
-			return 1;
+			goto destroy_ctx;
 		}
 	}
 
@@ -247,12 +248,12 @@ int main(int argc, char *argv[])
 
 	if (ctx_set_recv_wqes(&ctx,&user_param)) {
 		fprintf(stderr," Failed to post receive recv_wqes\n");
-		return 1;
+		goto destroy_ctx;
 	}
 
 	/* latency test function for SEND verb latency test. */
 	if (run_iter_lat_send(&ctx, &user_param)) {
-		return 17;
+		goto eexists;
 	}
 
 	/* print report (like print_report_bw) in the correct format
@@ -267,7 +268,7 @@ int main(int argc, char *argv[])
 		if (ibv_exp_destroy_flow(flow_promisc)) {
 			perror("error");
 			fprintf(stderr, "Couldn't Destory promisc flow\n");
-			return FAILURE;
+			goto destroy_ctx;
 		}
 	}
 	#endif
@@ -281,7 +282,7 @@ int main(int argc, char *argv[])
 		#endif
 			perror("error");
 			fprintf(stderr, "Couldn't Destory flow\n");
-			return FAILURE;
+			goto destroy_ctx;
 		}
 
 		free(flow_rules[i]);
@@ -291,7 +292,7 @@ int main(int argc, char *argv[])
 	if (destroy_ctx(&ctx, &user_param)) {
 		fprintf(stderr,"Failed to destroy_ctx\n");
 		DEBUG_LOG(TRACE,"<<<<<<%s",__FUNCTION__);
-		return 1;
+		return FAILURE;
 	}
 
 	if (user_param.output == FULL_VERBOSITY)
@@ -300,4 +301,12 @@ int main(int argc, char *argv[])
 	DEBUG_LOG(TRACE,"<<<<<<%s",__FUNCTION__);
 	return 0;
 
+eexists:
+	ret_val = 17;
+destroy_ctx:
+	destroy_ctx(&ctx, &user_param);
+free_flows:
+	free(flow_create_result);
+	free(flow_rules);
+	return ret_val;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
