From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 05/23] atomic_lat: fix assorted memory leaks on error paths
Date: Thu, 18 Aug 2016 13:32:00 -0400
Message-ID: <1471541538-20270-6-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These were all reported by clang.

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/atomic_lat.c | 52 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/src/atomic_lat.c b/src/atomic_lat.c
index fd61a14..213efe5 100755
--- a/src/atomic_lat.c
+++ b/src/atomic_lat.c
@@ -55,6 +55,7 @@
 int main(int argc, char *argv[])
 {
 	int				ret_parser, i;
+	int				ret_val = FAILURE;
 	struct report_options		report;
 	struct pingpong_context		ctx;
 	struct pingpong_dest		*my_dest  = NULL;
@@ -77,7 +78,7 @@ int main(int argc, char *argv[])
 	if (ret_parser) {
 		if (ret_parser != VERSION_EXIT && ret_parser != HELP_EXIT)
 			fprintf(stderr," Parser function exited with Error\n");
-		return 1;
+		return FAILURE;
 	}
 
 	if(user_param.use_xrc)
@@ -94,7 +95,7 @@ int main(int argc, char *argv[])
 	ctx.context = ibv_open_device(ib_dev);
 	if (!ctx.context) {
 		fprintf(stderr, " Couldn't get context for the device\n");
-		return 1;
+		return FAILURE;
 	}
 
 	#ifdef HAVE_MASKED_ATOMICS
@@ -105,7 +106,7 @@ int main(int argc, char *argv[])
 
 	if (user_param.masked_atomics && (user_param.work_rdma_cm || user_param.use_rdma_cm)) {
 		fprintf(stderr, "atomic test is not supported with -R/-z flag (rdma_cm) with this device.\n");
-		return 1;
+		return FAILURE;
 	}
 
 	#endif
@@ -119,7 +120,7 @@ int main(int argc, char *argv[])
 	/* copy the relevant user parameters to the comm struct + creating rdma_cm resources. */
 	if (create_comm_struct(&user_comm,&user_param)) {
 		fprintf(stderr," Unable to create RDMA_CM resources\n");
-		return 1;
+		return FAILURE;
 	}
 
 	if (user_param.output == FULL_VERBOSITY && user_param.machine == SERVER) {
@@ -158,17 +159,17 @@ int main(int argc, char *argv[])
 		if (user_param.machine == CLIENT) {
 			if (retry_rdma_connect(&ctx,&user_param)) {
 				fprintf(stderr,"Unable to perform rdma_client function\n");
-				return FAILURE;
+				goto free_dests;
 			}
 
 		} else {
 			if (create_rdma_resources(&ctx,&user_param)) {
 				fprintf(stderr," Unable to create the rdma_resources\n");
-				return FAILURE;
+				goto free_dests;
 			}
 			if (rdma_server_connect(&ctx,&user_param)) {
 				fprintf(stderr,"Unable to perform rdma_client function\n");
-				return FAILURE;
+				goto free_dests;
 			}
 		}
 
@@ -177,14 +178,14 @@ int main(int argc, char *argv[])
 		/* create all the basic IB resources (data buffer, PD, MR, CQ and events channel) */
 		if (ctx_init(&ctx,&user_param)) {
 			fprintf(stderr, " Couldn't create IB resources\n");
-			return FAILURE;
+			goto free_dests;
 		}
 	}
 
 	/* Set up the Connection. */
 	if (set_up_connection(&ctx,&user_param,my_dest)) {
 		fprintf(stderr," Unable to set up socket connection\n");
-		return 1;
+		goto destroy_ctx;
 	}
 
 	/* Print basic test information. */
@@ -196,7 +197,7 @@ int main(int argc, char *argv[])
 	/* shaking hands and gather the other side info. */
 	if (ctx_hand_shake(&user_comm,my_dest,rem_dest)) {
 		fprintf(stderr,"Failed to exchange data between server and clients\n");
-		return 1;
+		goto destroy_ctx;
 	}
 
 	user_comm.rdma_params->side = REMOTE;
@@ -205,7 +206,7 @@ int main(int argc, char *argv[])
 		/* shaking hands and gather the other side info. */
 		if (ctx_hand_shake(&user_comm,&my_dest[i],&rem_dest[i])) {
 			fprintf(stderr,"Failed to exchange data between server and clients\n");
-			return 1;
+			goto destroy_ctx;
 		}
 
 		ctx_print_pingpong_data(&rem_dest[i],&user_comm);
@@ -215,39 +216,39 @@ int main(int argc, char *argv[])
 		if (ctx_check_gid_compatibility(&my_dest[0], &rem_dest[0])) {
 			fprintf(stderr,"\n Found Incompatibility issue with GID types.\n");
 			fprintf(stderr," Please Try to use a different IP version.\n\n");
-			return 1;
+			goto destroy_ctx;
 		}
 	}
 
 	if (user_param.work_rdma_cm == OFF) {
 		if (ctx_connect(&ctx,rem_dest,&user_param,my_dest)) {
 			fprintf(stderr," Unable to Connect the HCA's through the link\n");
-			return 1;
+			goto destroy_ctx;
 		}
 	}
 
 	/* An additional handshake is required after moving qp to RTR. */
 	if (ctx_hand_shake(&user_comm,my_dest,rem_dest)) {
 		fprintf(stderr,"Failed to exchange data between server and clients\n");
-		return 1;
+		goto destroy_ctx;
 	}
 
 	/* Only Client post read request. */
 	if (user_param.machine == SERVER) {
 		if (ctx_close_connection(&user_comm,my_dest,rem_dest)) {
 			fprintf(stderr,"Failed to close connection between server and client\n");
-			return 1;
+			goto destroy_ctx;
 		}
 		if (user_param.output == FULL_VERBOSITY) {
 			printf(RESULT_LINE);
 		}
-		return 0;
+		goto out_success;
 	}
 
 	if (user_param.use_event) {
 		if (ibv_req_notify_cq(ctx.send_cq, 0)) {
 			fprintf(stderr, "Couldn't request CQ notification\n");
-			return 1;
+			goto destroy_ctx;
 		}
 	}
 
@@ -258,19 +259,28 @@ int main(int argc, char *argv[])
 		printf("%s",(user_param.test_type == ITERATIONS) ? RESULT_FMT_LAT : RESULT_FMT_LAT_DUR);
 		printf((user_param.cpu_util_data.enable ? RESULT_EXT_CPU_UTIL : RESULT_EXT));
 	}
-	if(run_iter_lat(&ctx,&user_param))
-		return 17;
+	if(run_iter_lat(&ctx,&user_param)) {
+		ret_val = 17;
+		goto destroy_ctx;
+	}
 
 	user_param.test_type == ITERATIONS ? print_report_lat(&user_param) : print_report_lat_duration(&user_param);
 
 	if (ctx_close_connection(&user_comm,my_dest,rem_dest)) {
 		fprintf(stderr,"Failed to close connection between server and client\n");
-		return 1;
+		goto destroy_ctx;
 	}
 
 	if (user_param.output == FULL_VERBOSITY) {
 		printf(RESULT_LINE);
 	}
 
-	return 0;
+out_success:
+	ret_val = 0;
+destroy_ctx:
+	destroy_ctx(&ctx,&user_param);
+free_dests:
+	free(my_dest);
+	free(rem_dest);
+	return ret_val;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
