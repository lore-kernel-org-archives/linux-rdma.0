From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 04/23] atomic_bw: fix assorted memory leaks on error paths
Date: Thu, 18 Aug 2016 13:31:59 -0400
Message-ID: <1471541538-20270-5-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These were all reported by clang. Also replaced all instances of "return
1" with "return FAILURE" for consistency.

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/atomic_bw.c | 55 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 24 deletions(-)

diff --git a/src/atomic_bw.c b/src/atomic_bw.c
index 479cb1d..3de5f4c 100755
--- a/src/atomic_bw.c
+++ b/src/atomic_bw.c
@@ -69,7 +69,7 @@ int main(int argc, char *argv[])
 	if (ret_parser) {
 		if (ret_parser != VERSION_EXIT && ret_parser != HELP_EXIT)
 			fprintf(stderr, " Parser function exited with Error\n");
-		return 1;
+		return FAILURE;
 	}
 
 	if (user_param.use_xrc && user_param.duplex) {
@@ -84,7 +84,7 @@ int main(int argc, char *argv[])
 	ctx.context = ibv_open_device(ib_dev);
 	if (!ctx.context) {
 		fprintf(stderr, " Couldn't get context for the device\n");
-		return 1;
+		return FAILURE;
 	}
 
 	#ifdef HAVE_MASKED_ATOMICS
@@ -95,7 +95,7 @@ int main(int argc, char *argv[])
 
 	if (user_param.masked_atomics && (user_param.work_rdma_cm || user_param.use_rdma_cm)) {
 		fprintf(stderr, "atomic test is not supported with -R/-z flag (rdma_cm) with this device.\n");
-		return 1;
+		return FAILURE;
 	}
 	#endif
 
@@ -108,7 +108,7 @@ int main(int argc, char *argv[])
 	/* copy the relevant user parameters to the comm struct + creating rdma_cm resources. */
 	if (create_comm_struct(&user_comm, &user_param)) {
 		fprintf(stderr, " Unable to create RDMA_CM resources\n");
-		return 1;
+		return FAILURE;
 	}
 
 	if (user_param.output == FULL_VERBOSITY && user_param.machine == SERVER) {
@@ -147,17 +147,17 @@ int main(int argc, char *argv[])
 		if (user_param.machine == CLIENT) {
 			if (retry_rdma_connect(&ctx, &user_param)) {
 				fprintf(stderr, "Unable to perform rdma_client function\n");
-				return FAILURE;
+				goto free_dests;
 			}
 
 		} else {
 			if (create_rdma_resources(&ctx, &user_param)) {
 				fprintf(stderr, " Unable to create the rdma_resources\n");
-				return FAILURE;
+				goto free_dests;
 			}
 			if (rdma_server_connect(&ctx, &user_param)) {
 				fprintf(stderr, "Unable to perform rdma_client function\n");
-				return FAILURE;
+				goto free_dests;
 			}
 		}
 
@@ -166,14 +166,14 @@ int main(int argc, char *argv[])
 		/* create all the basic IB resources. */
 		if (ctx_init(&ctx, &user_param)) {
 			fprintf(stderr, " Couldn't create IB resources\n");
-			return FAILURE;
+			goto free_dests;
 		}
 	}
 
 	/* Set up the Connection. */
 	if (set_up_connection(&ctx, &user_param, my_dest)) {
 		fprintf(stderr, " Unable to set up socket connection\n");
-		return FAILURE;
+		goto destroy_ctx;
 	}
 
 	/* Print basic test information. */
@@ -189,7 +189,7 @@ int main(int argc, char *argv[])
 		/* shaking hands and gather the other side info. */
 		if (ctx_hand_shake(&user_comm, &my_dest[i], &rem_dest[i])) {
 			fprintf(stderr, "Failed to exchange data between server and clients\n");
-			return 1;
+			goto destroy_ctx;
 		}
 		ctx_print_pingpong_data(&rem_dest[i], &user_comm);
 	}
@@ -198,21 +198,21 @@ int main(int argc, char *argv[])
 		if (ctx_check_gid_compatibility(&my_dest[0], &rem_dest[0])) {
 			fprintf(stderr, "\n Found Incompatibility issue with GID types.\n");
 			fprintf(stderr, " Please Try to use a different IP version.\n\n");
-			return 1;
+			goto destroy_ctx;
 		}
 	}
 
 	if (user_param.work_rdma_cm == OFF) {
 		if (ctx_connect(&ctx, rem_dest, &user_param, my_dest)) {
 			fprintf(stderr, " Unable to Connect the HCA's through the link\n");
-			return 1;
+			goto destroy_ctx;
 		}
 	}
 
 	/* An additional handshake is required after moving qp to RTR. */
 	if (ctx_hand_shake(&user_comm, &my_dest[0], &rem_dest[0])) {
 		fprintf(stderr, "Failed to exchange data between server and clients\n");
-		return 1;
+		goto destroy_ctx;
 	}
 
 	/* For half duplex tests, server just waits for client to exit */
@@ -225,7 +225,7 @@ int main(int argc, char *argv[])
 
 		if (ctx_hand_shake(&user_comm, &my_dest[0], &rem_dest[0])) {
 			fprintf(stderr, " Failed to exchange data between server and clients\n");
-			return FAILURE;
+			goto destroy_ctx;
 		}
 
 		xchg_bw_reports(&user_comm, &my_bw_rep, &rem_bw_rep, atof(user_param.rem_version));
@@ -237,7 +237,7 @@ int main(int argc, char *argv[])
 
 		if (ctx_close_connection(&user_comm, &my_dest[0], &rem_dest[0])) {
 			fprintf(stderr, "Failed to close connection between server and client\n");
-			return 1;
+			goto destroy_ctx;
 		}
 
 		return destroy_ctx(&ctx, &user_param);
@@ -246,7 +246,7 @@ int main(int argc, char *argv[])
 	if (user_param.use_event) {
 		if (ibv_req_notify_cq(ctx.send_cq, 0)) {
 			fprintf(stderr, "Couldn't request CQ notification\n");
-			return 1;
+			goto destroy_ctx;
 		}
 	}
 	if (user_param.output == FULL_VERBOSITY) {
@@ -261,19 +261,19 @@ int main(int argc, char *argv[])
 
 		if (perform_warm_up(&ctx, &user_param)) {
 			fprintf(stderr, "Problems with warm up\n");
-			return 1;
+			goto destroy_ctx;
 		}
 
 		if (user_param.duplex) {
 			if (ctx_hand_shake(&user_comm, &my_dest[0], &rem_dest[0])) {
 				fprintf(stderr, "Failed to sync between server and client between different msg sizes\n");
-				return 1;
+				goto destroy_ctx;
 			}
 		}
 
 		if (run_iter_bw(&ctx, &user_param)) {
 			fprintf(stderr, " Error occured in run_iter function\n");
-			return 1;
+			goto destroy_ctx;
 		}
 
 		print_report_bw(&user_param, &my_bw_rep);
@@ -302,7 +302,7 @@ int main(int argc, char *argv[])
 
 		if (run_iter_bw_infinitely(&ctx, &user_param)) {
 			fprintf(stderr, " Error occured while running infinitely! aborting ...\n");
-			return 1;
+			goto destroy_ctx;
 		}
 	}
 
@@ -314,7 +314,7 @@ int main(int argc, char *argv[])
 
 		if (ctx_hand_shake(&user_comm, &my_dest[0], &rem_dest[0])) {
 			fprintf(stderr, " Failed to exchange data between server and clients\n");
-			return FAILURE;
+			goto destroy_ctx;
 		}
 
 		xchg_bw_reports(&user_comm, &my_bw_rep, &rem_bw_rep, atof(user_param.rem_version));
@@ -322,18 +322,25 @@ int main(int argc, char *argv[])
 
 	if (ctx_close_connection(&user_comm, &my_dest[0], &rem_dest[0])) {
 		fprintf(stderr, "Failed to close connection between server and client\n");
-		return 1;
+		goto destroy_ctx;
 	}
 
 	if (!user_param.is_bw_limit_passed && (user_param.is_limit_bw == ON)) {
 		fprintf(stderr, "Error: BW result is below bw limit\n");
-		return 1;
+		goto destroy_ctx;
 	}
 
 	if (!user_param.is_msgrate_limit_passed && (user_param.is_limit_bw == ON)) {
 		fprintf(stderr, "Error: Msg rate  is below msg_rate limit\n");
-		return 1;
+		goto destroy_ctx;
 	}
 
 	return destroy_ctx(&ctx, &user_param);
+
+destroy_ctx:
+	destroy_ctx(&ctx,&user_param);
+free_dests:
+	free(my_dest);
+	free(rem_dest);
+	return FAILURE;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
