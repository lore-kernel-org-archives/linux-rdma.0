From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 03/23] send_bw: fix assorted memory leaks on error paths
Date: Thu, 18 Aug 2016 13:31:58 -0400
Message-ID: <1471541538-20270-4-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Clang reported a bunch of memory leaks. This plugs 'em all.

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/send_bw.c | 100 ++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 59 insertions(+), 41 deletions(-)

diff --git a/src/send_bw.c b/src/send_bw.c
index b018aa1..45cbb67 100755
--- a/src/send_bw.c
+++ b/src/send_bw.c
@@ -162,6 +162,7 @@ int main(int argc, char *argv[])
 	struct bw_report_data		my_bw_rep, rem_bw_rep;
 	int                      	ret_parser,i = 0;
 	int                      	size_max_pow = 24;
+	int				ret_val = FAILURE;
 
 	/* init default values to user's parameters */
 	memset(&ctx, 0,sizeof(struct pingpong_context));
@@ -178,7 +179,7 @@ int main(int argc, char *argv[])
 	if (ret_parser) {
 		if (ret_parser != VERSION_EXIT && ret_parser != HELP_EXIT)
 			fprintf(stderr," Parser function exited with Error\n");
-		return 1;
+		return ret_val;
 	}
 	if((user_param.connection_type == DC || user_param.use_xrc) && user_param.duplex) {
 		user_param.num_of_qps *= 2;
@@ -187,14 +188,14 @@ int main(int argc, char *argv[])
 	if (user_param.connection_type == RawEth) {
 		fprintf(stderr," This test cannot run Raw Ethernet QPs (you have chosen RawEth as connection type\n");
 		fprintf(stderr," For this we have raw_ethernet_bw test in this package.\n");
-		return FAILURE;
+		return ret_val;
 	}
 
 	/* Finding the IB device selected (or defalut if no selected). */
 	ib_dev = ctx_find_dev(user_param.ib_devname);
 	if (!ib_dev) {
 		fprintf(stderr," Unable to find the Infiniband/RoCE device\n");
-		return 1;
+		return ret_val;
 	}
 
 	if (user_param.use_mcg)
@@ -204,20 +205,20 @@ int main(int argc, char *argv[])
 	ctx.context = ibv_open_device(ib_dev);
 	if (!ctx.context) {
 		fprintf(stderr, " Couldn't get context for the device\n");
-		return 1;
+		goto free_ib_devname;
 	}
 
 
 	/* See if MTU and link type are valid and supported. */
 	if (check_link(ctx.context,&user_param)) {
 		fprintf(stderr, " Couldn't get context for the device\n");
-		return FAILURE;
+		goto free_ib_devname;
 	}
 
 	/* copy the relevant user parameters to the comm struct + creating rdma_cm resources. */
 	if (create_comm_struct(&user_comm,&user_param)) {
 		fprintf(stderr," Unable to create RDMA_CM resources\n");
-		return 1;
+		goto free_ib_devname;
 	}
 
 	if (user_param.output == FULL_VERBOSITY && user_param.machine == SERVER) {
@@ -229,7 +230,7 @@ int main(int argc, char *argv[])
 	/* Initialize the connection and print the local data. */
 	if (establish_connection(&user_comm)) {
 		fprintf(stderr," Unable to init the socket connection\n");
-		return FAILURE;
+		goto free_ib_devname;
 	}
 
 	exchange_versions(&user_comm, &user_param);
@@ -239,7 +240,7 @@ int main(int argc, char *argv[])
 	/* See if MTU and link type are valid and supported. */
 	if (check_mtu(ctx.context,&user_param, &user_comm)) {
 		fprintf(stderr, " Couldn't get context for the device\n");
-		return FAILURE;
+		goto free_ib_devname;
 	}
 
 	ALLOCATE(my_dest , struct pingpong_dest , user_param.num_of_qps);
@@ -259,17 +260,17 @@ int main(int argc, char *argv[])
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
 
@@ -278,14 +279,14 @@ int main(int argc, char *argv[])
 		/* create all the basic IB resources (data buffer, PD, MR, CQ and events channel) */
 		if (ctx_init(&ctx,&user_param)) {
 			fprintf(stderr, " Couldn't create IB resources\n");
-			return FAILURE;
+			goto free_dests;
 		}
 	}
 
 	/* Set up the Connection. */
 	if (send_set_up_connection(&ctx,&user_param,my_dest,&mcg_params,&user_comm)) {
 		fprintf(stderr," Unable to set up socket connection\n");
-		return 1;
+		goto destroy_ctx;
 	}
 
 	/* Print basic test information. */
@@ -303,7 +304,7 @@ int main(int argc, char *argv[])
 		/* shaking hands and gather the other side info. */
 		if (ctx_hand_shake(&user_comm,&my_dest[i],&rem_dest[i])) {
 			fprintf(stderr,"Failed to exchange data between server and clients\n");
-			return 1;
+			goto destroy_ctx;
 		}
 
 		ctx_print_pingpong_data(&rem_dest[i],&user_comm);
@@ -313,7 +314,7 @@ int main(int argc, char *argv[])
 		if (ctx_check_gid_compatibility(&my_dest[0], &rem_dest[0])) {
 			fprintf(stderr,"\n Found Incompatibility issue with GID types.\n");
 			fprintf(stderr," Please Try to use a different IP version.\n\n");
-			return 1;
+			goto destroy_ctx;
 		}
 	}
 
@@ -330,7 +331,7 @@ int main(int argc, char *argv[])
 		memcpy(mcg_params.mgid.raw, rem_dest[0].gid.raw, 16);
 		if (set_mcast_group(&ctx,&user_param,&mcg_params)) {
 			fprintf(stderr," Unable to Join Sender to Mcast gid\n");
-			return 1;
+			goto destroy_ctx;
 		}
 		/*
 		 * The next stall in code (50 ms sleep) is a work around for fixing the
@@ -349,26 +350,26 @@ int main(int argc, char *argv[])
 		/* Prepare IB resources for rtr/rts. */
 		if (ctx_connect(&ctx,rem_dest,&user_param,my_dest)) {
 			fprintf(stderr," Unable to Connect the HCA's through the link\n");
-			return 1;
+			goto destroy_ctx;
 		}
 	}
 
 	/* shaking hands and gather the other side info. */
 	if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
 		fprintf(stderr,"Failed to exchange data between server and clients\n");
-		return 1;
+		goto destroy_ctx;
 	}
 
 	if (user_param.use_event) {
 
 		if (ibv_req_notify_cq(ctx.send_cq, 0)) {
 			fprintf(stderr, " Couldn't request CQ notification\n");
-			return 1;
+			goto destroy_ctx;
 		}
 
 		if (ibv_req_notify_cq(ctx.recv_cq, 0)) {
 			fprintf(stderr, " Couldn't request CQ notification\n");
-			return 1;
+			goto destroy_ctx;
 		}
 	}
 
@@ -399,13 +400,13 @@ int main(int argc, char *argv[])
 			if (user_param.machine == SERVER || user_param.duplex) {
 				if (ctx_set_recv_wqes(&ctx,&user_param)) {
 					fprintf(stderr," Failed to post receive recv_wqes\n");
-					return 1;
+					goto destroy_ctx;
 				}
 			}
 
 			if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
 				fprintf(stderr,"Failed to exchange data between server and clients\n");
-				return 1;
+				goto destroy_ctx;
 			}
 
 			if (ctx.send_rcredit) {
@@ -415,19 +416,23 @@ int main(int argc, char *argv[])
 			}
 
 			if (user_param.duplex) {
-				if(run_iter_bi(&ctx,&user_param))
-					return 17;
+				if(run_iter_bi(&ctx,&user_param)) {
+					ret_val = 17;
+					goto destroy_ctx;
+				}
 
 			} else if (user_param.machine == CLIENT) {
 
 				if(run_iter_bw(&ctx,&user_param)) {
-					return 17;
+					ret_val = 17;
+					goto destroy_ctx;
 				}
 
 			} else	{
 
 				if(run_iter_bw_server(&ctx,&user_param)) {
-					return 17;
+					ret_val = 17;
+					goto destroy_ctx;
 				}
 			}
 
@@ -439,7 +444,7 @@ int main(int argc, char *argv[])
 			}
 			if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
 				fprintf(stderr,"Failed to exchange data between server and clients\n");
-				return 1;
+				goto destroy_ctx;
 			}
 
 			/* Check if last iteration ended well in UC/UD */
@@ -456,29 +461,33 @@ int main(int argc, char *argv[])
 		if (user_param.machine == SERVER || user_param.duplex) {
 			if (ctx_set_recv_wqes(&ctx,&user_param)) {
 				fprintf(stderr," Failed to post receive recv_wqes\n");
-				return 1;
+				goto destroy_ctx;
 			}
 		}
 
 		if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
 			fprintf(stderr,"Failed to exchange data between server and clients\n");
-			return 1;
+			goto destroy_ctx;
 		}
 
 		if (user_param.duplex) {
 
-			if(run_iter_bi(&ctx,&user_param))
-				return 17;
+			if(run_iter_bi(&ctx,&user_param)) {
+				ret_val = 17;
+				goto destroy_ctx;
+			}
 
 		} else if (user_param.machine == CLIENT) {
 
 			if(run_iter_bw(&ctx,&user_param)) {
-				return 17;
+				ret_val = 17;
+				goto destroy_ctx;
 			}
 
 		} else if(run_iter_bw_server(&ctx,&user_param)) {
 
-			return 17;
+			ret_val = 17;
+			goto destroy_ctx;
 		}
 
 		print_report_bw(&user_param,&my_bw_rep);
@@ -512,27 +521,27 @@ int main(int argc, char *argv[])
 
 			if (ctx_set_recv_wqes(&ctx,&user_param)) {
 				fprintf(stderr," Failed to post receive recv_wqes\n");
-				return 1;
+				goto destroy_ctx;
 			}
 		}
 
 		if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
 			fprintf(stderr,"Failed to exchange data between server and clients\n");
-			return 1;
+			goto destroy_ctx;
 		}
 
 		if (user_param.machine == CLIENT) {
 
 			if(run_iter_bw_infinitely(&ctx,&user_param)) {
 				fprintf(stderr," Error occured while running infinitely! aborting ...\n");
-				return 1;
+				goto destroy_ctx;
 			}
 
 		} else if (user_param.machine == SERVER) {
 
 			if(run_iter_bw_infinitely_server(&ctx,&user_param)) {
 				fprintf(stderr," Error occured while running infinitely on server! aborting ...\n");
-				return 1;
+				goto destroy_ctx;
 			}
 		}
 	}
@@ -552,25 +561,34 @@ int main(int argc, char *argv[])
 	/* Destory all test resources, including Mcast if exists */
 	if (send_destroy_ctx(&ctx,&user_param,&mcg_params)) {
 		fprintf(stderr,"Couldn't Destory all SEND resources\n");
-		return FAILURE;
+		goto destroy_ctx;
 	}
 	if (user_param.work_rdma_cm == ON) {
 		user_comm.rdma_params->work_rdma_cm = ON;
 		if (destroy_ctx(user_comm.rdma_ctx,user_comm.rdma_params)) {
 			fprintf(stderr,"Failed to destroy resources\n");
-			return 1;
+			goto destroy_ctx;
 		}
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
 
 	return 0;
+
+destroy_ctx:
+	destroy_ctx(&ctx,&user_param);
+free_dests:
+	free(my_dest);
+	free(rem_dest);
+free_ib_devname:
+	free(mcg_params.ib_devname);
+	return ret_val;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
