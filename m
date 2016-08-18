From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 09/23] write_bw: fix assorted memory leaks on error paths
Date: Thu, 18 Aug 2016 13:32:04 -0400
Message-ID: <1471541538-20270-10-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Leaks all reported by clang/coverity.

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/write_bw.c | 81 ++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 45 insertions(+), 36 deletions(-)

diff --git a/src/write_bw.c b/src/write_bw.c
index 63422a8..1ee426c 100755
--- a/src/write_bw.c
+++ b/src/write_bw.c
@@ -48,6 +48,7 @@
 int main(int argc, char *argv[])
 {
 	int				ret_parser,i = 0;
+	int				ret_val = FAILURE;
 	struct ibv_device		*ib_dev = NULL;
 	struct pingpong_context		ctx;
 	struct pingpong_dest		*my_dest,*rem_dest;
@@ -69,7 +70,7 @@ int main(int argc, char *argv[])
 	if (ret_parser) {
 		if (ret_parser != VERSION_EXIT && ret_parser != HELP_EXIT)
 			fprintf(stderr," Parser function exited with Error\n");
-		return 1;
+		return FAILURE;
 	}
 
 	if((user_param.connection_type == DC || user_param.use_xrc) && user_param.duplex) {
@@ -80,14 +81,14 @@ int main(int argc, char *argv[])
 	ib_dev = ctx_find_dev(user_param.ib_devname);
 	if (!ib_dev) {
 		fprintf(stderr," Unable to find the Infiniband/RoCE device\n");
-		return 1;
+		return FAILURE;
 	}
 
 	/* Getting the relevant context from the device */
 	ctx.context = ibv_open_device(ib_dev);
 	if (!ctx.context) {
 		fprintf(stderr, " Couldn't get context for the device\n");
-		return 1;
+		return FAILURE;
 	}
 
 	/* See if MTU and link type are valid and supported. */
@@ -99,7 +100,7 @@ int main(int argc, char *argv[])
 	/* copy the relevant user parameters to the comm struct + creating rdma_cm resources. */
 	if (create_comm_struct(&user_comm,&user_param)) {
 		fprintf(stderr," Unable to create RDMA_CM resources\n");
-		return 1;
+		return FAILURE;
 	}
 
 	if (user_param.output == FULL_VERBOSITY && user_param.machine == SERVER) {
@@ -138,17 +139,17 @@ int main(int argc, char *argv[])
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
 
@@ -157,14 +158,14 @@ int main(int argc, char *argv[])
 		/* create all the basic IB resources (data buffer, PD, MR, CQ and events channel) */
 		if (ctx_init(&ctx, &user_param)) {
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
@@ -181,7 +182,7 @@ int main(int argc, char *argv[])
 
 		if (ctx_hand_shake(&user_comm,&my_dest[i],&rem_dest[i])) {
 			fprintf(stderr," Failed to exchange data between server and clients\n");
-			return 1;
+			goto destroy_ctx;
 		}
 
 		ctx_print_pingpong_data(&rem_dest[i],&user_comm);
@@ -191,21 +192,21 @@ int main(int argc, char *argv[])
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
-			return FAILURE;
+			goto destroy_ctx;
 		}
 	}
 
 	/* An additional handshake is required after moving qp to RTR. */
 	if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
 		fprintf(stderr," Failed to exchange data between server and clients\n");
-		return FAILURE;
+		goto destroy_ctx;
 	}
 
 	if (user_param.output == FULL_VERBOSITY) {
@@ -226,7 +227,7 @@ int main(int argc, char *argv[])
 
 		if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
 			fprintf(stderr," Failed to exchange data between server and clients\n");
-			return FAILURE;
+			goto destroy_ctx;
 		}
 
 		xchg_bw_reports(&user_comm, &my_bw_rep,&rem_bw_rep,atof(user_param.rem_version));
@@ -234,7 +235,7 @@ int main(int argc, char *argv[])
 
 		if (ctx_close_connection(&user_comm,&my_dest[0],&rem_dest[0])) {
 			fprintf(stderr,"Failed to close connection between server and client\n");
-			return 1;
+			goto destroy_ctx;
 		}
 
 		if (user_param.output == FULL_VERBOSITY) {
@@ -247,13 +248,15 @@ int main(int argc, char *argv[])
 		if (user_param.work_rdma_cm == ON) {
 			if (destroy_ctx(&ctx,&user_param)) {
 				fprintf(stderr, "Failed to destroy resources\n");
-				return 1;
+				goto free_dests;
 			}
 			user_comm.rdma_params->work_rdma_cm = ON;
-			return destroy_ctx(user_comm.rdma_ctx,user_comm.rdma_params);
+			ret_val = destroy_ctx(user_comm.rdma_ctx,user_comm.rdma_params);
+			goto free_dests;
 		}
 
-		return destroy_ctx(&ctx,&user_param);
+		ret_val = destroy_ctx(&ctx,&user_param);
+		goto free_dests;
 	}
 
 	if (user_param.test_method == RUN_ALL) {
@@ -265,25 +268,25 @@ int main(int argc, char *argv[])
 
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
 
 			if(run_iter_bw(&ctx,&user_param)) {
 				fprintf(stderr," Failed to complete run_iter_bw function successfully\n");
-				return 1;
+				goto destroy_ctx;
 			}
 
 			if (user_param.duplex && (atof(user_param.version) >= 4.6)) {
 				if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
 					fprintf(stderr,"Failed to sync between server and client between different msg sizes\n");
-					return 1;
+					goto destroy_ctx;
 				}
 			}
 
@@ -302,20 +305,20 @@ int main(int argc, char *argv[])
 		if (user_param.verb != SEND) {
 			if(perform_warm_up(&ctx,&user_param)) {
 				fprintf(stderr,"Problems with warm up\n");
-				return 1;
+				goto destroy_ctx;
 			}
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
@@ -346,7 +349,7 @@ int main(int argc, char *argv[])
 
 		if(run_iter_bw_infinitely(&ctx,&user_param)) {
 			fprintf(stderr," Error occured while running infinitely! aborting ...\n");
-			return 1;
+			goto destroy_ctx;
 		}
 	}
 
@@ -362,7 +365,7 @@ int main(int argc, char *argv[])
 
 		if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
 			fprintf(stderr," Failed to exchange data between server and clients\n");
-			return FAILURE;
+			goto destroy_ctx;
 		}
 
 		xchg_bw_reports(&user_comm, &my_bw_rep,&rem_bw_rep,atof(user_param.rem_version));
@@ -371,30 +374,36 @@ int main(int argc, char *argv[])
 	/* Closing connection. */
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
 
-	free(my_dest);
-	free(rem_dest);
-
 	if (user_param.work_rdma_cm == ON) {
 		if (destroy_ctx(&ctx,&user_param)) {
 			fprintf(stderr, "Failed to destroy resources\n");
-			return 1;
+			goto free_dests;
 		}
 		user_comm.rdma_params->work_rdma_cm = ON;
-		return destroy_ctx(user_comm.rdma_ctx,user_comm.rdma_params);
+		ret_val = destroy_ctx(user_comm.rdma_ctx,user_comm.rdma_params);
+		goto free_dests;
 	}
 
-	return destroy_ctx(&ctx,&user_param);
+	ret_val = destroy_ctx(&ctx,&user_param);
+	goto free_dests;
+
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
