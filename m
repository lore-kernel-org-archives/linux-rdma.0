From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 07/23] read_bw: fix assorted memory leaks on error paths
Date: Thu, 18 Aug 2016 13:32:02 -0400
Message-ID: <1471541538-20270-8-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Reported by clang/coverity.

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/read_bw.c | 76 ++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 29 deletions(-)

diff --git a/src/read_bw.c b/src/read_bw.c
index 47afcdb..17f75dc 100755
--- a/src/read_bw.c
+++ b/src/read_bw.c
@@ -48,6 +48,7 @@
 int main(int argc, char *argv[])
 {
 	int                        ret_parser,i = 0;
+	int			   ret_val = FAILURE;
 	struct ibv_device	   *ib_dev = NULL;
 	struct pingpong_context    ctx;
 	struct pingpong_dest       *my_dest = NULL;
@@ -69,7 +70,7 @@ int main(int argc, char *argv[])
 	if (ret_parser) {
 		if (ret_parser != VERSION_EXIT && ret_parser != HELP_EXIT)
 			fprintf(stderr," Parser function exited with Error\n");
-		return 1;
+		return FAILURE;
 	}
 
 	if((user_param.connection_type == DC || user_param.use_xrc) && user_param.duplex) {
@@ -84,7 +85,7 @@ int main(int argc, char *argv[])
 	ctx.context = ibv_open_device(ib_dev);
 	if (!ctx.context) {
 		fprintf(stderr, " Couldn't get context for the device\n");
-		return 1;
+		return FAILURE;
 	}
 
 	/* See if MTU and link type are valid and supported. */
@@ -96,7 +97,7 @@ int main(int argc, char *argv[])
 	/* copy the relevant user parameters to the comm struct + creating rdma_cm resources. */
 	if (create_comm_struct(&user_comm,&user_param)) {
 		fprintf(stderr," Unable to create RDMA_CM resources\n");
-		return 1;
+		return FAILURE;
 	}
 
 	if (user_param.output == FULL_VERBOSITY && user_param.machine == SERVER) {
@@ -135,17 +136,17 @@ int main(int argc, char *argv[])
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
 
@@ -153,14 +154,14 @@ int main(int argc, char *argv[])
 		/* create all the basic IB resources. */
 		if (ctx_init(&ctx,&user_param)) {
 			fprintf(stderr, " Couldn't create IB resources\n");
-			return FAILURE;
+			goto free_dests;
 		}
 	}
 
 	/* Set up the Connection. */
 	if (set_up_connection(&ctx,&user_param,my_dest)) {
 		fprintf(stderr," Unable to set up socket connection\n");
-		return FAILURE;
+		goto destroy_ctx;
 	}
 
 	/* Print basic test information. */
@@ -177,7 +178,7 @@ int main(int argc, char *argv[])
 		/* shaking hands and gather the other side info. */
 		if (ctx_hand_shake(&user_comm,&my_dest[i],&rem_dest[i])) {
 			fprintf(stderr,"Failed to exchange data between server and clients\n");
-			return 1;
+			goto destroy_ctx;
 		}
 		ctx_print_pingpong_data(&rem_dest[i],&user_comm);
 	}
@@ -186,7 +187,7 @@ int main(int argc, char *argv[])
 		if (ctx_check_gid_compatibility(&my_dest[0], &rem_dest[0])) {
 			fprintf(stderr,"\n Found Incompatibility issue with GID types.\n");
 			fprintf(stderr," Please Try to use a different IP version.\n\n");
-			return 1;
+			goto destroy_ctx;
 		}
 	}
 
@@ -194,14 +195,14 @@ int main(int argc, char *argv[])
 
 		if (ctx_connect(&ctx,rem_dest,&user_param,my_dest)) {
 			fprintf(stderr," Unable to Connect the HCA's through the link\n");
-			return 1;
+			goto destroy_ctx;
 		}
 	}
 
 	/* An additional handshake is required after moving qp to RTR. */
 	if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
 		fprintf(stderr,"Failed to exchange data between server and clients\n");
-		return 1;
+		goto destroy_ctx;
 	}
 
 	if (user_param.output == FULL_VERBOSITY) {
@@ -221,7 +222,7 @@ int main(int argc, char *argv[])
 
 		if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
 			fprintf(stderr," Failed to exchange data between server and clients\n");
-			return FAILURE;
+			goto destroy_ctx;
 		}
 
 		xchg_bw_reports(&user_comm, &my_bw_rep,&rem_bw_rep,atof(user_param.rem_version));
@@ -229,7 +230,7 @@ int main(int argc, char *argv[])
 
 		if (ctx_close_connection(&user_comm,&my_dest[0],&rem_dest[0])) {
 			fprintf(stderr,"Failed to close connection between server and client\n");
-			return 1;
+			goto destroy_ctx;
 		}
 		if (user_param.output == FULL_VERBOSITY) {
 			if (user_param.report_per_port)
@@ -241,12 +242,16 @@ int main(int argc, char *argv[])
 		if (user_param.work_rdma_cm == ON) {
 			if (destroy_ctx(&ctx,&user_param)) {
 				fprintf(stderr, "Failed to destroy resources\n");
-				return 1;
+				goto free_dests;
 			}
 			user_comm.rdma_params->work_rdma_cm = ON;
+			free(my_dest);
+			free(rem_dest);
 			return destroy_ctx(user_comm.rdma_ctx,user_comm.rdma_params);
 		}
 
+		free(my_dest);
+		free(rem_dest);
 		return destroy_ctx(&ctx,&user_param);
 
 	}
@@ -254,7 +259,7 @@ int main(int argc, char *argv[])
 	if (user_param.use_event) {
 		if (ibv_req_notify_cq(ctx.send_cq, 0)) {
 			fprintf(stderr, "Couldn't request CQ notification\n");
-			return 1;
+			goto destroy_ctx;
 		}
 	}
 
@@ -267,23 +272,23 @@ int main(int argc, char *argv[])
 
 			if(perform_warm_up(&ctx,&user_param)) {
 				fprintf(stderr,"Problems with warm up\n");
-				return 1;
+				goto destroy_ctx;
 			}
 
 			if(user_param.duplex) {
 				if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
 					fprintf(stderr,"Failed to sync between server and client between different msg sizes\n");
-					return 1;
+					goto destroy_ctx;
 				}
 			}
 
 			if(run_iter_bw(&ctx,&user_param))
-				return 17;
+				goto eexists;
 
 			if (user_param.duplex && (atof(user_param.version) >= 4.6)) {
 				if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
 					fprintf(stderr,"Failed to sync between server and client between different msg sizes\n");
-					return 1;
+					goto destroy_ctx;
 				}
 			}
 
@@ -301,19 +306,19 @@ int main(int argc, char *argv[])
 
 		if(perform_warm_up(&ctx,&user_param)) {
 			fprintf(stderr,"Problems with warm up\n");
-			return 1;
+			goto destroy_ctx;
 		}
 
 		if(user_param.duplex) {
 			if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
 				fprintf(stderr,"Failed to sync between server and client between different msg sizes\n");
-				return 1;
+				goto destroy_ctx;
 			}
 		}
 
 		if(run_iter_bw(&ctx,&user_param)) {
 			fprintf(stderr," Failed to complete run_iter_bw function successfully\n");
-			return 1;
+			goto destroy_ctx;
 		}
 
 		print_report_bw(&user_param,&my_bw_rep);
@@ -344,7 +349,7 @@ int main(int argc, char *argv[])
 
 		if(run_iter_bw_infinitely(&ctx,&user_param)) {
 			fprintf(stderr," Error occured while running! aborting ...\n");
-			return 1;
+			goto destroy_ctx;
 		}
 	}
 
@@ -360,7 +365,7 @@ int main(int argc, char *argv[])
 
 		if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
 			fprintf(stderr," Failed to exchange data between server and clients\n");
-			return FAILURE;
+			goto destroy_ctx;
 		}
 
 		xchg_bw_reports(&user_comm, &my_bw_rep,&rem_bw_rep,atof(user_param.rem_version));
@@ -368,27 +373,40 @@ int main(int argc, char *argv[])
 
 	if (ctx_close_connection(&user_comm,&my_dest[0],&rem_dest[0])) {
 		fprintf(stderr,"Failed to close connection between server and client\n");
-		return 1;
+		goto destroy_ctx;
 	}
 
 	if (!user_param.is_bw_limit_passed && (user_param.is_limit_bw == ON ) ) {
 		fprintf(stderr,"Error: BW result is below bw limit\n");
-		return 1;
+		goto destroy_ctx;
 	}
 
 	if (!user_param.is_msgrate_limit_passed && (user_param.is_limit_bw == ON )) {
 		fprintf(stderr,"Error: Msg rate  is below msg_rate limit\n");
-		return 1;
+		goto destroy_ctx;
 	}
 
 	if (user_param.work_rdma_cm == ON) {
 		if (destroy_ctx(&ctx,&user_param)) {
 			fprintf(stderr, "Failed to destroy resources\n");
-			return 1;
+			goto free_dests;
 		}
 		user_comm.rdma_params->work_rdma_cm = ON;
+		free(my_dest);
+		free(rem_dest);
 		return destroy_ctx(user_comm.rdma_ctx,user_comm.rdma_params);
 	}
 
+	free(my_dest);
+	free(rem_dest);
 	return destroy_ctx(&ctx,&user_param);
+
+eexists:
+	ret_val = 17;
+destroy_ctx:
+	destroy_ctx(&ctx, &user_param);
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
